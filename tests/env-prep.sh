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
  # We should never need to do this as supposedly pip is now
  # part of python3 but because .. fedora
  curl -fsSL https://bootstrap.pypa.io/get-pip.py | python3
}

ansible-prereqs-install() {
  dnf install -y \
    gcc          \
    libffi-devel \
    python3-devel
}

fedora-prereqs-install() {
  rpm --import "https://src.fedoraproject.org/rpms/fedora-repos/raw/master/f/RPM-GPG-KEY-fedora-${VERSION_ID}-primary"
  NEXT_VERSION_ID=$(( VERSION_ID + 1 ))
  rpm --import "https://src.fedoraproject.org/rpms/fedora-repos/raw/master/f/RPM-GPG-KEY-fedora-${NEXT_VERSION_ID}-primary"
}

# Workaround for when pip3 isn't setup as a command
# This always ensures pip from python3 is used.
pip() {
  python3 -m pip "$@"
}

[[ $ID == 'fedora' ]]   && fedora-prereqs-install
python3 --version       || python3-install
python3 -c 'import pip' || pip3-install
[[ $ID == fedora ]]     && ansible-prereqs-install

pip install --upgrade ansible
ansible --version
