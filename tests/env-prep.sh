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
  dnf install -y   \
    gcc            \
    libffi-devel   \
    python3        \
    python3-devel  \
    python3-pip    \
    python3-setuptools \
    python3-wheel

elif type -P yum; then
  source /etc/os-release
  if [[ $ID = rhel ]]; then
    pyno=36  # python 3.6
    [[ $VERSION_ID == 8* ]] && pyno=38 # python 3.8 on ubi8
    yum --enablerepo=* makecache
    yum --enablerepo=* install -y   \
      curl gcc libffi-devel         \
      rh-python$pyno-python            \
      rh-python$pyno-python-devel      \
      rh-python$pyno-python-pip        \
      rh-python$pyno-python-setuptools \
      rh-python$pyno-python-wheel

    # https://www.softwarecollections.org/en/scls/rhscl/rh-python36/
    scl enable rh-python36 bash  # wtf?
  else
    yum install -y curl python3 python3-pip python3-setuptools
  fi

fi

python3 --version

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

