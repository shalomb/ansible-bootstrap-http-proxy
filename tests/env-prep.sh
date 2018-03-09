#!/bin/bash

set -eu
set -xv

# setup
if type -P apt; then
  apt-get -qq -y update
  apt-get install -y --no-install-recommends curl python-minimal
elif type -P zypper; then
  zypper -n install curl python python-xml
elif type -P dnf; then
  dnf install -y curl python
elif type -P yum; then
  yum install -y curl python
fi

curl https://bootstrap.pypa.io/get-pip.py | python

pip install pip

pip install ansible

