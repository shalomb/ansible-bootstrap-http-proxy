#!/bin/bash

set -eu
set -xv

# setup
if type -P apt; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get -qq -y update
  apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates curl \
    python3-minimal python3-setuptools python3-wheel

elif type -P zypper; then
  zypper -n install curl python python-xml

elif type -P dnf; then
  dnf install -y curl python3 python3-pip python3-setuptools

elif type -P yum; then
  source /etc/os-release
  if [[ $ID = rhel ]]; then
    curl http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
      -o /tmp/epel.rpm
    rpm -ivh /tmp/epel.rpm
    yum --disablerepo=* --enablerepo=epel install -y \
      python3 python3-pip python3-setuptools
  else
    yum install -y curl python3 python3-pip python3-setuptools
  fi

fi

# Workaround for when pip3 isn't setup
pip3() {
  python3 -m pip "$@";
}

pip3 install --upgrade pip || true

if ! type -P pip3; then
  curl https://bootstrap.pypa.io/get-pip.py | python3
fi

pip3 install --upgrade ansible==2.8.0

ansible --version

