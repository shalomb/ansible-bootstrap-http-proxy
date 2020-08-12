#!/bin/bash

set -eu
set -xv

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

python3 --version || python3-install

if ! python3 -c 'import pip'; then
  # We should never need to do this as supposedly pip is now
  # part of python3
  curl -fsSL https://bootstrap.pypa.io/get-pip.py | python3
fi

# Workaround for when pip3 isn't setup as a command
# This always ensures pip from python3 is used.
pip() {
  python3 -m pip "$@"
}

pip install --upgrade ansible

ansible --version

