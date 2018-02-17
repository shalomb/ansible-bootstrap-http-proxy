#!/bin/bash

set -xv

# setup
if type -P apt; then
  apt-get install -y curl
elif type -P zypper; then
  zypper -n install curl
fi

curl https://bootstrap.pypa.io/get-pip.py | python

pip install pip

pip install ansible

ansible-playbook -i tests/test.yml -vv

