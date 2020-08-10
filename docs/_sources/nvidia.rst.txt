:github_url: https://github.com/project-faros/faros.dev/blob/master/source/nvidia.rst

NVIDIA Support
==============

In order to consume GPU resources on the cluster, the NVIDIA GPU support must
be deployed. NVIDIA support requires that all nodes in the cluster are
entitled to pull RHEL content. In order to set this up, the bastion node must
be running RHEL. These entitlements will be copied to the cluster.

To setup NVIDIA Support:

.. code-block:: bash

    farosctl install-plan nvidia-support

This install plan is the equivalent to running all of the following commands.

.. code-block:: bash

   # deploy red hat entitlements to the cluster
   farosctl deploy redhat-entitlements

   # install nvidia drivers on the cluster nodes
   farosctl deploy nvidia-drivers

After the install is completed, it will take quite some time for all of the
changes to be applied. Each node will need to have their configuration updated
and be restarted. Watch the cluster console and wait for the operators to
finish.
