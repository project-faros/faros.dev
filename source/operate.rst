:github_url: https://github.com/project-faros/faros.dev/blob/master/source/operate.rst

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

Configure user accounts
-----------------------

There are many options for configuring user accounts in OpenShift. Two common
methods are `using LDAP authentication
<https://docs.openshift.com/container-platform/4.4/authentication/identity_providers/configuring-ldap-identity-provider.html>`_
or `using an HTPasswd file
<https://docs.openshift.com/container-platform/4.4/authentication/identity_providers/configuring-htpasswd-identity-provider.html>`_.


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

Destroying the cluster
----------------------

The installed cluster can be destroyed to safely prepare for another install.
The following commands perform this procedure.

.. code-block:: bash

   # Destroy the OpenShift cluster and wipe all hard drives in cluster nodes.
   farosctl destroy cluster

   # Clear all installation sources including CoreOS images and configurations
   farosctl destroy install-repos

   # Remove the Load Balancer that fronts the cluster
   farosctl destroy load-balancer

Alternatively, all of these processes can be triggered in succession.

.. code-block:: bash

   farosctl destroy

.. important::

   While ALL disks on ALL cluster nodes will be wiped as part of this process,
   they are NOT securely wiped. Only the partition tables and volume
   definitions are erased. To easily ensure the data on these drives can never
   be accessed again, either securely wipe them using a third party tool or
   erase the Tang server's keys at /var/db/tang on the bastion server.
