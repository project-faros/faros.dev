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

There is currently a known issue with storage that causes some nuisance
warnings to be thrown. If the *lib-bucket-provisioner* operator is flapping on
your cluster after a storage install, the instructions to fix this can be found
`here <https://access.redhat.com/solutions/5221881>`_.

Set default StorageClass
------------------------

Once storage is available to the cluster, it is a good practice to set the
default StorageClass. Official documentation is here for `changing the default
StorageClass <https://docs.openshift.com/container-platform/4.4/storage/dynamic-provisioning.html#change-default-storage-class_dynamic-provisioning>`_.
To set the CephFS storage class to be the default, use the following command:

.. code-block:: bash

  oc patch storageclass ocs-storagecluster-cephfs -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'

Enable cluster registry
-----------------------

Because storage is not originally available in a bare metal deployment, the
cluster image registry cannot be enabled by default.
Now that the storage is available, it is time to `enable the cluster registry <https://docs.openshift.com/container-platform/4.4/registry/configuring-registry-operator.html#registry-removed_configuring-registry-operator>`_.

To enable cluster storage, edit the
:code:`config.imageregistry.operator.openshift.io/cluster` resource.

.. code-block:: bash

  oc edit config.imageregistry.operator.openshift.io/cluster

First, change the value for :code:`spec.managementState` to *Managed*. Then
configure :code:`spec.storage` to create a PersistentVolumeClaim.

After making these changes, watch the operator status indicator on the
OpenShift console. When the indicator goes green and doesn't show anymore
cluster operators pending, the configuration change is complete.

Here is an example :code:`config.imageregistry.operator.openshift.io/cluster` resource.

.. code-block:: yaml

    apiVersion: imageregistry.operator.openshift.io/v1
    kind: Config
    metadata:
      finalizers:
      - imageregistry.operator.openshift.io/finalizer
      name: cluster
    spec:
      logging: 2
      managementState: Managed
      proxy: {}
      replicas: 1
      requests:
        read:
          maxWaitInQueue: 0s
        write:
          maxWaitInQueue: 0s
      rolloutStrategy: RollingUpdate
      storage:
        pvc:
          claim:

Enable registry pruning
-----------------------

Once the registry is enabled, image pruning should also be enabled to reduce
clutter. To enable cluster storage, edit the
:code:`imagepruner.imageregistry.operator.openshift.io/cluster` resource.

.. code-block:: bash

  oc edit imagepruner.imageregistry.operator.openshift.io/cluster

The value for :code:`spec.suspended` should be set to *false*.

After making this change, watch the operator status indicator on the
OpenShift console. When the indicator goes green and doesn't show anymore
cluster operators pending, the configuration change is complete.

The :code:`imagepruner.imageregistry.operator.openshift.io/cluster` resource
definition should look like the following.

.. code-block:: yaml

  apiVersion: imageregistry.operator.openshift.io/v1
  kind: ImagePruner
  metadata:
    name: cluster
  spec:
    failedJobsHistoryLimit: 3
    keepTagRevisions: 3
    schedule: ""
    successfulJobsHistoryLimit: 3
    suspend: false
