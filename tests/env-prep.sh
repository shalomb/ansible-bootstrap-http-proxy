#!/bin/bash

set -eu
set -xv

source /etc/os-release

python3-install() {
  if type -P apt; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get -qq -y update
    apt-get install -y \
      --no-install-recommends --no-install-suggests \
      apt-transport-https \
      ca-certificates     \
      curl                \
      python3-minimal     \
      python3-pip         \
      python3-setuptools  \
      python3-wheel

  elif type -P dnf || type -P yum; then
    pkg=yum
    type -P dnf && pkg=dnf
    $pkg install -y      \
      python3            \
      python3-pip        \
      python3-setuptools \
      python3-wheel

  fi
}

pip3-install() {
  pyver=$(python3 -c 'import sys;print(sys.version[0:3])')

  if [[ $pyver == '3.5' ]]; then
    # NOTE: Python 3.5 is to be deprecated on September 13th, 2020.
    curl -fsSL https://bootstrap.pypa.io/pip/3.5/get-pip.py | python3
  else
    curl -fsSL https://bootstrap.pypa.io/get-pip.py | python3
  fi

  # This seemingly is the only way to "register" the pip3 install on
  # python <= 3.5 despite the above suceeding .. heh
  python3 -m pip install -U pip
}

ansible-prereqs-install() {
  dnf install -y \
    gcc          \
    libffi-devel \
    python3-devel
}

fedora-prereqs-install() {
  local NEXT_VERSION_ID=$(( VERSION_ID + 1 ))
  local keys=(
    # This should always succeed.
    # even on rawhide?
    "https://src.fedoraproject.org/rpms/fedora-repos/raw/master/f/RPM-GPG-KEY-fedora-${VERSION_ID}-primary"

    # This should fail on rawhide.
    "https://src.fedoraproject.org/rpms/fedora-repos/raw/master/f/RPM-GPG-KEY-fedora-${NEXT_VERSION_ID}-primary"
  )

  for url in "${keys[@]}"; do
    if curl -fsSLI "$url"; then
      rpm -vvvv --import "$url"
    fi
  done
}

# Workaround for when pip3 isn't setup as a command
# This always ensures pip from python3 is used.
pip() {
  python3 -m pip "$@"
}

[[ $ID == 'fedora' ]]   && fedora-prereqs-install
python3 --version       || python3-install
pip3-install
[[ $ID == fedora ]]     && ansible-prereqs-install

pip install --upgrade ansible
ansible --version
