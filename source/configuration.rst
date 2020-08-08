:github_url: https://github.com/project-faros/faros.dev/blob/master/source/configuration.rst

Cluster Configuration
=====================

Before begining the cluster deployement, it is necessary to confirm the
hardware and network setup. Then, the cluster configuration options can be set.

Hardware configuration
----------------------

The boot order of each node must be the following:

  * OS hard drive
  * IPv4 PXE using the cluster connected NIC
  * Everything else

Both UEFI and legacy booting are supported.

For the out of band management, each node must use the same username/password
for control and be configured to use DHCP when joining the network.

All drives in the nodes should be blank before begining the installation. There
should not be an operating system installed on any drive of the cluster nodes
as this can cause issues booting CoreOS, particularly in UEFI mode.

Network initial condition
-------------------------

Before starting the cluster deployement, it is required that each node is
connected to the layer 2 switch that will be used by the cluster. It is highly
recomended to leave the out-of-band management NICs disconnected when starting
the deployment. During the deployment process, you will be instructed when to
connect them.

.. important::

    It is highly recomended to leave the out of band management interfaces
    disconnected when begining cluster deployement.

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
    internal network.
    Selecting more than one NIC allows connecting more devices to the
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
    Your pull secret from `cloud.redhat.com <https://cloud.redhat.com/openshift/install/pull-secret>`_

Host Record Configuration
+++++++++++++++++++++++++

The following options are available:

Machine Management Provider
    The protocol used to talk to the hosts' out-of-bandmanagement interface.
    Currently only iLo can be used.

Machine Management User
    The username that should be used when accessing the out-of-band management
    interfaces.

Machine Management Password
    The password that should be used when accessing the out-of-band management
    interfaces.

Control Plane Machines
    This interface allows configuration of each of the bare metal machines that
    will be used to create the OpenShift control plane. Each node requires
    three values:

      * *Node Name*: The hostname that will be given to the node. Note: This is
        not the FQDN, just the hostname.
      * *MAC Address*: The MAC address for the node's cluster connected NIC
      * *Management MAC Address*: The MAC address for the node's out-of-bande
        management interface

Extra DNS/DHCP Records
++++++++++++++++++++++

These options allow for additional configuration of the DNS and DHCP services
beyond the minimum required for a cluster deployment. They exist, mostly, for
convenience.

Static IP Reservations
    Any additional static records that should be configured in the DNS and DHCP
    servers. For example, WiFi access points, chassis management interfaces,
    bastion node out-of-band management, and any additional custom servers.
    Each extra record requires the following information:

      * *Node Name*: The hostname that will be given to the node. Note: This is
        not the FQDN, just the hostname.
      * *MAC Address*: The MAC address for the node's cluster connected NIC
      * *Requested IP Address*: The IP address that is desired for the record.
        The request will be ignored if the IP address has already been asigned
        on the network. This can be left blank to have an available static IP
        address automatically assigned.

DHCP Ignored MAC Addresses
    If there are any interfaces on the cluster layer 2 network that you do not
    want to be able to dynamically obtain an IP address, you must configure
    them here. The entries here will be ignored when making DHCP requests.
    Note: This does not provide the security of forcing them off the network.
    It only precents them from obtaining the network details dynamically. These
    records require the following information:

      * *Entry Name*: A unique name for the record to make it recognizable
      * *MAC Address*: The MAC address for the node's cluster connected NIC
