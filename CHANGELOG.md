v1.0.9 2020-08-26T22:17:31
--------------------------

* Fix break in testing fedora:rawhide where package signing keys for
  the nonexistent next version could not be imported

v1.0.8 2020-08-19T16:07:12
--------------------------

* Fix test failures on fedora:rawhide

v1.0.7 2020-08-12T09:53:05
--------------------------

* Migrate testbed to python3, ansible==2.8
* Limit testing to bleeding-edge versions of the major distributions.
  This is to keep the test requirements low-complexity (python3 hell)
  and really, this role does not depend on any particulars of python.
* Switch to UBI instead of in-the-wild RHEL docker images
* Update metadata
