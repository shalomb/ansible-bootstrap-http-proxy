#!/bin/bash

set -eu
set -xv

# setup
if type -P apt; then
  apt-get install -y curl python-minimal
elif type -P zypper; then
  zypper -n install curl python
elif type -P dnf; then
  dnf install -y curl python
elif type -P yum; then
  yum install -y curl python
fi

curl https://bootstrap.pypa.io/get-pip.py | python

pip install pip

pip install ansible

ansible-playbook -i tests/test.yml -vv

