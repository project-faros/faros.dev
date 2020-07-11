:github_url: https://github.com/project-faros/faros.dev/blob/master/source/configuration.rst

Cluster Configuration
=====================

Before begining the cluster deployement, it is necessary to confirm the
hardware and network setup. Then, the cluster configuration options can be set.

Node prerequisites
------------------

The BIOS configuration of the nodes will largely not impact the Faros
deployment process. However, it is mandatory that the boot order of each node
be the following:

  * OS hard drive
  * Cluster connected NIC
  * Everything else

It is also required that each node in the cluster use the same username and
password for their out-of-band management interface.

Network initial condition
-------------------------

Before starting the cluster deployement, it is required that each node is
connected to the layer 2 switch that will be used by the cluster. It is highly
recomended to leave the out-of-band management NICs disconnected when starting
the deployment. During the deployment process, you will be instructed to when
connect them.

.. note::

    It is possible to leave the management interfaces connected during the
    entire install process, but there may be a delay waiting for them to get
    properly addressed.

OpenShift cluster configuration
-------------------------------

The Faros CLI provides a TUI to make configuring the cluster easy. To launch
the configuration interface, run the following command as the administrative
user::

    farosctl config

Router Configuration
++++++++++++++++++++

The following options are available:

LAN Interfaces
    Select which NICs on the bastion node should be put onto the cluster
    network. Selecting more than one NIC allows connecting more devices to the
    cluster network. For example, you may select a 10gbe NIC and a 1gbe NIC to
    be on the cluster network so that you can attach a 1gbe switch and a 10gbe
    switch to the network.

Subnet
    The subnet IP definition that should be used for cluster nodes. When using
    the gateway in PAT mode, this decision is far less impactful.

Subnet Mask
    The CIDR prefix for the subnet.

Premitted Ingress Traffic
    These options control the firewall configuration. They control what traffic
    is allowed into the cluster. The following modes are available and can be
    toggled on/off individually

      * *SSH to Bastion* - Allow external nodes to SSH to the bastion
      * *HTTPS to Cluster API* - Allow external nodes to contact the OpenShift
        API
      * *HTTP to Cluster Apps* - Allow external nodes to contact applications
        running in the OpenShift cluster via HTTP
      * *HTTPS to Cluster Apps* - Allow external nodes to contact applications
        running in the OpenShift cluster via HTTPS
      * *HTTPS to Cockpit Panel* - Allow external nodes to connect to the
        Cockpit control plane running on port 9090 on the bastion via HTTPS
      * *External to Internal Routing - DANGER* - This configures the gateway
        in NAT mode as opposed to PAT mode. USE WITH CAUTION.

Cluster Configuration
+++++++++++++++++++++

The following options are available:

Administrator Password
    The password required for the administrator user on the bastion node. This
    is used to allow the installer to use sudo.

Pull Secret
    Your pull secret from `cloud.redhat.com <https://cloud.redhat.com>`_

Host Record Configuration
+++++++++++++++++++++++++

The following options are available:

Machine Management Provider
    The protocol used to talk to the hosts' management interface. Currently
    only iLo can be used.

Machine Management User
    The user with access to the hosts' management interface

Machine Management Password
    The password associated with the management user

Bastion Node Management MAC Address
    The MAC address of the network interface on the bastion node's management
    interface

Control Plane Machines
    This interface allows configuration of each of the bare metal machines that
    will be used to create the OpenShift control plane. Each node requires
    three values:

      * *Node Name*: The hostname that will be given to the node. Note: This is
        not the FQDN, just the hostname.
      * *MAC Address*: The MAC address for the node's cluster connected NIC
      * *Management MAC Address*: The MAC address for the node's management
        interface

Extra DNS/DHCP Records
++++++++++++++++++++++

These options allow for additional configuration of the DNS and DHCP services
beyond the minimum required for a cluster deployment. They exist, mostly, for
convenience.

Extra Records
    Any additional static records that should be configured in the DNS and DHCP
    servers. For example, WiFi access points, chassis management interfaces,
    additional custom servers. Each extra record requires the following
    information:

      * *Node Name*: The hostname that will be given to the node. Note: This is
        not the FQDN, just the hostname.
      * *MAC Address*: The MAC address for the node's cluster connected NIC

Ignored MAC Addresses
    If there are any interfaces on the cluster layer 2 network that you do not
    want to be able to dynamically obtain an IP address, you must configure
    them here. The entries here will be ignored when making DHCP requests.
    Note: This does not provide the security of forcing them off the network.
    It only precents them from obtaining the network details dynamically. These
    records require the following information:

      * *Entry Name*: A unique name for the record to make it recognizable
      * *MAC Address*: The MAC address for the node's cluster connected NIC
