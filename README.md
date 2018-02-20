ansible-bootstrap-http-proxy
============================

[![Build Status](https://travis-ci.org/shalomb/ansible-bootstrap-http-proxy.svg?branch=master)](https://travis-ci.org/shalomb/ansible-bootstrap-http-proxy)

Ansible role to configure the following HTTP/HTTPS/FTP proxy
environment variables in `/etc/environment` using shell commands and
the `raw:` module. This is needed on targets behind a proxy that
require this configuration to complete the bootstrap of
python2.x

- `HTTP_PROXY` and `http_proxy`
- `HTTPS_PROXY` and `https_proxy`
- `FTP_PROXY` and `ftp_proxy`
- `NO_PROXY` and `no_proxy`

Both upper-case and lower-case variables are set even if either variant
is provided.

Requirements
------------

The targets are linux systems and environment variables can be set
in `/etc/environment`

Role Variables
--------------

Role Inputs
-----------

- `HTTP_PROXY`
- `http_proxy`
- `HTTPS_PROXY`
- `https_proxy`
- `FTP_PROXY`
- `ftp_proxy`
- `NO_PROXY`
- `no_proxy`

Dependencies
------------

The following shell utilities (which are typically available on most
GNU/Linux systems) are utilized by the role.

- `cat(1)`  from [GNU Coreutils](https://www.gnu.org/software/coreutils/coreutils.html)
- `echo(1)` from [GNU Coreutils](https://www.gnu.org/software/coreutils/coreutils.html)
- `grep(1)`
- `sed(1)`
- `tee(1)`  from [GNU Coreutils](https://www.gnu.org/software/coreutils/coreutils.html)

Example Playbook
----------------

All the relevant proxy environment variables (`HTTPS?_PROXY`, `FTPS?_PROXY` and
their lower-case equivalents) are configured even though only
`http_proxy` is provided.

    - name: Configure http/https/ftp proxy environment variables
      hosts: all
      any_errors_fatal: True
      gather_facts: no
      roles:
        - name: ansible-bootstrap-http-proxy
          http_proxy: 'http://proxy.example.org:9091'
      tags:
        - http-proxy

