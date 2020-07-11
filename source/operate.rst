Day 2 Cluster Operation
=======================

Start up and shutdown procedures
--------------------------------

The Faros tooling includes scripts for automated cluster shutdown and startup:

.. code-block:: bash

    # Safely stop and bring down the cluster
    farosctl shutdown
    # Shutdown the bastion node
    poweroff

    # Bring the cluster up and wait for it to be healthy
    farosctl startup

Updating the cluster
--------------------

Patch the cluster
+++++++++++++++++

The OpenShift cluster may be patched by following the standard procedures. It
is recomened to use the GUI for patching. The official Red Hat documentation
containers detailed `OpenShift updating instructions <https://docs.openshift.com/container-platform/4.4/updating/updating-cluster.html>`_.

Patch the bastion node
++++++++++++++++++++++

To patch the bastion node, simply:

.. code-block:: bash

    dnf -y update
    reboot

Please note, there will be a cluster disruption while the bastion node is
patched. Cluster services will continue to run, but they will be unavailable.

Deploying container storage
---------------------------

There are many options for persistent cluster storage, but OpenShift Container
Storage (OCS) is preferred for a few reasons:

  - OCS is gauranteed to work with OpenShift
  - OCS provides file, block, and object storage support RWX
  - OCS runs on the cluster nodes and does not require additional hardware

To run through an automated storage deployment, use the following command:

.. code-block:: bash

  farosctl deploy container-storage

This will launch an interactive menu to choose which nodes should be used for
storage and then which drives on those nodes should be dedicated to storage.
OCS requires full block devices on the nodes and cannot simply use part of a
partitioned drive. The drive must be wipped prior to building the storage
cluster.

Once storage is available to the cluster, it is a good practice to set the
default StorageClass. Official documentation is here for `changing the default
StorageClass <https://docs.openshift.com/container-platform/4.4/storage/dynamic-provisioning.html#change-default-storage-class_dynamic-provisioning>`_.

Enable cluster registry
-----------------------

Because storage is not originally available in a bare metal deployment, the
cluster image registry cannot be created until after storage is made available.
Now the storage is available, it is time to `enable the cluster registry <https://docs.openshift.com/container-platform/4.4/registry/configuring-registry-operator.html#registry-removed_configuring-registry-operator>`_.

Configure user accounts
-----------------------

There are many options for configuring user accounts in OpenShift. Two common
methods are `using LDAP authentication
<https://docs.openshift.com/container-platform/4.4/authentication/identity_providers/configuring-ldap-identity-provider.html>`_
or `using an HTPasswd file
<https://docs.openshift.com/container-platform/4.4/authentication/identity_providers/configuring-htpasswd-identity-provider.html>`_.

Deploying Open Data Hub demo
----------------------------

To demonstrate the capabilities of OpenShift for data scientists, a demo Open
Data Hub environment can be quickly deployed using the following command:

.. code-block:: bash

    farosctl deploy odh-demo

.. note::

    Open Data Hub is a community supported project and not a Red Hat product.
    Deployment of this demo requires that storge and the cluster registry have
    both been configured.

Configure cluster HTTPS certs
-----------------------------

Not strictly necessary, but often desireable, official documentation is
available on how to `update the application HTTPS certificate
<https://docs.openshift.com/container-platform/4.4/authentication/certificates/replacing-default-ingress-certificate.html>`_
and on how to `update the API HTTPS certificate
<https://docs.openshift.com/container-platform/4.4/authentication/certificates/api-server.html>`_.

Add nodes to the cluster
------------------------

To add additional application nodes to the cluster, the DHCP and DNS zones on
the bastion must be manually updated to add records for that host and configure
them to PXE boot to the CoreOS installer with the worker ignition file.
Detailed instructions are available for `creating RHCOS machines with PXE
booting
<https://docs.openshift.com/container-platform/4.4/installing/installing_bare_metal/installing-bare-metal.html#installation-user-infra-machines-pxe_installing-bare-metal>`_.
