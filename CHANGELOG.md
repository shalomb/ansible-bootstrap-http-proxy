v1.0.7 2020-08-12T09:53:05
--------------------------

* Migrate testbed to python3, ansible==2.8
* Limit testing to bleeding-edge versions of the major distributions.
  This is to keep the test requirements low-complexity (python3 hell)
  and really, this role does not depend on any particulars of python.
* Switch to UBI instead of in-the-wild RHEL docker images
* Update metadata
