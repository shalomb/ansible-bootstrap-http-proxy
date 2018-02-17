ansible-bootstrap-http-proxy
===========================

Configure the following environment variables in `/etc/environment`
using shell commands using the `raw:` module. This is needed on targets
where the following vars are needed to complete the bootstrap of
python2.x

- `HTTP_PROXY` and `http_proxy`
- `HTTPS_PROXY` and `https_proxy`
- `FTP_PROXY` and `ftp_proxy`
- `NO_PROXY` and `no_proxy`

Both upper-case and lower-case variables are set even if only one type
is provided.

Requirements
------------

The targets are linux systems and environment variables can be set
in `/etc/environment`

Role Variables
--------------

- `one_proxy: True`

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

In this play, all the necessary environment variables are configured
even though only `http_proxy` is provided.

    - name: Configure http/https/ftp proxy environment variables
      hosts: all
      any_errors_fatal: True
      gather_facts: no
      roles:
        - name: ansible-bootstrap-http-proxy
          http_proxy: 'http://proxy.example.org:9091'
      tags:
        - http-proxy

In this example play, only the `http_proxy` environment variable is
configured due to `one_proxy: False`. `https_proxy` and `ftp_proxy`
variables (and their upper case variants) are untouched.

    - name: Configure http_proxy environment variable
      hosts: all
      any_errors_fatal: True
      gather_facts: no
      roles:
        - name: ansible-bootstrap-http-proxy
          http_proxy: 'http://proxy.example.org:9091'
          no_proxy:   'localhost,127.*.*.*,169.254.*.*'
          one_proxy:  False
      tags:
        - http-proxy

