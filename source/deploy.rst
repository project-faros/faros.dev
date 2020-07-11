:github_url: https://github.com/project-faros/faros.dev/blob/master/source/deploy.rst

Cluster Deployment
==================

Now that the hardware has been wired and the Faros has been configured, the
cluster can be deployed.

Deploy the cluster
------------------

Run the following commands as your administrative user. (Not root)

.. code-block:: bash

    # Apply configuration to the router components.
    #   - Gateway, Firewall, DNS, DHCP, and NTP
    farosctl apply router

    # Create necessary virtual machines. Currently just the bootstrap.
    farosctl create machines

    # Configue cluster nodes in network services.
    #   - DNS, DHCP, and Cockpit
    farosctl apply host-records

    #
    # It is now safe to connect the management interfaces to the network
    #

    # Wait for maangement interfaces to become available.
    farosctl wait-for management-interfaces

    # Create the cluster load balancer.
    farosctl create load-balancer

    # Create the installation sources and machine config repositories.
    farosctl create install-repos

    # Create the OpenShift cluster.
    # This will boot all of the cluster nodes, install Red Hat CoreOS on each
    # node, and install OpenShift.
    farosctl create cluster

*Voila!*

Public DNS records
------------------

This step is not required, but will usually be desired. If you would like to
reach the cluster from an external machine, you will need to create a few
public DNS records. The content of the records will be slightly difference
depending on the gatway routing method used (NAT or PAT). Use the following
command to determine what your records should be:

.. code-block:: bash

    farosctl get public-dns-records

For a NATed network, you will get output like this:

.. code-block:: text

    ; Public DNS records for faros.site zone.
    bastion.edge.example.com.   IN  A   192.168.5.16
    api.edge.example.com.       IN  A   192.168.8.2
    *.apps.edge.example.com.    IN  A   192.168.8.2

For a PATed network, you will get output like this:

.. code-block:: text

    ; Public DNS records for faros.site zone.
    bastion.edge.example.com.   IN  A   192.168.5.16
    api.edge.example.com.       IN  A   192.168.5.16
    *.apps.edge.example.com.    IN  A   192.168.5.16

Connecting to the cluster
-------------------------

The cluster credentials are displayed at the end of the cluster deployment
process. If you need to retreive them again, use the following command:

.. code-block:: bash

    farosctl get credentials

This will return the cluster API domain, the cluster console domain, and the
kubeadmin password. You may use these to login to the OpenShift GUI or the
OpenShift CLI.

Node auth certificates
----------------------

Kubernetes uses OpenSSL certificates for internode authentication. The initial
set of these certificates are only valid for 24 hours. At that point, they are
automatically rotated by the cluster. Every subsequent set of certificates is
valid for 30 days. To avoid issues, do not shutdown the cluster in the first 24
hours. After that, do not leave the cluster powered off for longer than 30
days.

Debugging installation
----------------------

If issues are encountered during the cluster deployment process, add a `-v`
flag to the `farosctl` command for increased verbosity. Adding more v's will
increase the verbosity futher.
