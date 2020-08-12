#!/bin/bash

set -eu
set -xv

python3-install() {
  source /etc/os-release

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

    if [[ $ID == fedora ]]; then
      $pkg install -y      \
        gcc                \
        libffi-devel
    fi
  fi
}

pip3-install() {
  # We should never need to do this as supposedly pip is now
  # part of python3
  curl -fsSL https://bootstrap.pypa.io/get-pip.py | python3
}

# Workaround for when pip3 isn't setup as a command
# This always ensures pip from python3 is used.
pip() {
  python3 -m pip "$@"
}

python3 --version       || python3-install
python3 -c 'import pip' || pip3-install

pip install --upgrade ansible
ansible --version
