:github_url: https://github.com/project-faros/faros.dev/blob/master/source/storage.rst

Cluster Persistent Storage
==========================

There are many options for persistent cluster storage, but OpenShift Container
Storage (OCS) is preferred for a few reasons:

  - OCS is guaranteed to work with OpenShift
  - OCS provides file, block, and object storage support RWX
  - OCS runs on the cluster nodes and does not require additional hardware

OCS requires full block devices on the nodes and cannot simply use part of a
partitioned drive.

.. note::

   Before begining the storage install, make sure you have `connected to the
   cluster. <https://faros.dev/deploy.html#connecting-to-the-cluster>`_

Container storage deployment
----------------------------

Before deploying the cluster storage, you must ensure the drives to be used for
storage are wiped. Wiping the drives has been automated. Use the following
command and select the drives you would like to wipe.

.. code-block:: bash

  farosctl deploy wipefs

To run through an automated storage deployment, use the following command:

.. code-block:: bash

  farosctl deploy container-storage

This will launch an interactive menu to choose which nodes should be used for
storage and then which drives on those nodes should be dedicated to storage.
After completing this menu, OpenShift Container Storage will be deployed and
the cluster will begin building the hosted Ceph cluster. Wait until the storage
status indicators on the OpenShift console turn green before continuing.

