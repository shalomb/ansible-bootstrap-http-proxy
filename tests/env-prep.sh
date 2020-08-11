#!/bin/bash

set -eu
set -xv

# setup
if type -P apt; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get -qq -y update
  apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates curl \
    python3-minimal python3-setuptools python3-wheel python3-pip

elif type -P zypper; then
  zypper -n install curl python python-xml

elif type -P dnf; then
  dnf install -y curl python3 python3-pip python3-setuptools python3-wheel
  dnf install -y gcc  # build essentials
  # libffi-devel python-devel - may be needed for pip install cffi ansible

elif type -P yum; then
  source /etc/os-release
  if [[ $ID = rhel ]]; then
    curl http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
      -o /tmp/epel.rpm
    rpm -ivh /tmp/epel.rpm
    yum makecache
    yum --enablerepo=epel install -y \
      python3 python3-pip python3-setuptools
  else
    yum install -y curl python3 python3-pip python3-setuptools
  fi

fi

if ! python3 -c 'import pip'; then
  curl https://bootstrap.pypa.io/get-pip.py | python3
fi

# Workaround for when pip3 isn't setup
pip3() {
  python3 -m pip "$@";
}

pip3 install --upgrade setuptools
pip3 install --upgrade ansible==2.8.0

ansible --version

