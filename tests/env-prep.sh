#!/bin/bash

set -eu
set -xv

# setup
if type -P apt; then
  apt-get -qq -y update
  apt-get install -y python-minimal
elif type -P zypper; then
  zypper -n install python
elif type -P dnf; then
  dnf install -y python
elif type -P yum; then
  yum install -y python
fi

