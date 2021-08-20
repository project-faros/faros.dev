:github_url: https://github.com/project-faros/faros.dev/blob/master/source/configuration.rst

Cluster Configuration
=====================

Before begining the cluster deployement, it is necessary to confirm the
hardware and network setup. Then, the cluster configuration options can be set.

Hardware configuration
----------------------

A few settings on the hardware of the cluster node firmware must be properly
configured for the installation to work.

1. Both UEFI and Legacy/BIOS booting are supported, however, the boot order of
   each node must be the following:

    1. OS hard drive
    2. IPv4 PXE using the cluster connected NIC
    3. Everything else

2. For the out of band management, each node must use the same username
   and password for control.

3. The out of band management interface must be configured to use DHCP when
   joining the network.

4. All drives in the nodes should be blank before begining the installation.
   There should not be an operating system installed on any drive of the
   cluster nodes as this can cause issues booting CoreOS, particularly in UEFI
   mode.

5. The hardware system clock must be properly set.

6. Repeat for each node.

These settings can be configured before starting the deployment or during. If
you require access to the cluster nodes' out-of-band management interfaces to
perform this configuration then wait until during the deployment. The
deployment will pause once the out-of-band management interfaces have an IP
Address.

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
    Select which NICs on the bastion node should be put onto the cluster's
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
        in router mode as opposed to port forwarding mode. USE WITH CAUTION.

Upstream DNS Forwarders
    By default, the cluster's DNS server will use 1.1.1.1 to forward out of
    zone DNS requests. This option may be used to set alternate servers for
    these purposes.

Cluster Configuration
+++++++++++++++++++++

The following options are available:

Administrator Password
    The password required for the administrator user on the bastion node. This
    is used to allow the installer to use sudo.

Pull Secret
    Your pull secret from `cloud.redhat.com <https://cloud.redhat.com/openshift/install/pull-secret>`_

FIPS Mode:
    This option indictes if FIPS mode should be enabled on the cluster.

.. important::

    Enabling FIPS mode on the cluster **WILL NOT** configure FIPS on the bastion
    node. FIPS on the bastion node should be enabled at install time. Enabling
    FIPS on the cluster may break the functionality of some applications.

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
      * *Network Interface*: *[OPTIONAL]* The NIC on the node that should be
        configured on the cluster network.

          * If this is left blank, the network interface will be be configured by DHCP on every boot. A static IP assignement will be made on the DHCP server.
          * If a single NIC is configured (ex: eno5), after the first boot, the NIC will be configured to manually set the node's IP address without using DHCP.
          * A network bond can be configured here using the sytax `NIC0,NIC1:MODE` (ex: eno4,eno4:balance-xor). In this situation, the IP address will be statically assigned and the bond will be configured. The node must still be able to boot using a single NIC in order to PXE boot. Configuring the backing network switching architecture to support bonding is out of scope of the installer. For the bonding mode, balance-rr, active-backup, balance-xor, broadcast, and 802.3ad are the only supported options.

      * *MAC Address*: The MAC address for the node's cluster connected NIC. In
        the case of a bond, this should be the MAC address of the first NIC in
        the bond. The first NIC in the bond must be able to come up
        independantly without the second NIC for PXE booting.
      * *Management IP*: This field is only required if the *Management MAC
        Address* is not provided. Using this field to specify on IP address for
        the out of band management interface allows those interfaces to be on
        a network seperate from the cluster network. This is better for static
        installs as it increases availability, but decreases portability.
      * *Management MAC Address*: This field is only required if the
        *Management IP* is not provided. Using this field to specify the MAC
        address of the out of band management interface allows the installer to
        provision an address for the management interface on the cluster
        network. This reduces the availability of the management interfaces as
        the bastion node will need to be on and reachable to interact with the
        management interfaces. However, it greatly increases portability of the
        installed cluster as no additional networks are required.
      * *OS Install Drive*: This drive in the node onto which CoreOS will be
        installed. Address the drive by name only. Eg: sda

Container Cache Disk
    *[OPTIONAL]* Configuring this setting will move the container cache
    directories on the host (/var/lib/kubelet and /var/lib/containers) to a
    secondary disk. This greatly improves the performance on three node
    clusters. This is less important if an NVME is used for the OS drive. The
    container cache disk **MUST BE** at least 100 GB. Address the drive by name
    only. Eg: sdb

Bastion Node Guest
++++++++++++++++++

The following options configure a virtual cluster node on the bastion.

Create app node VM on bastion
    A switch to enable or disable the bastion node guest VM configuration.

Node name
    The hostname to assign to the VM.

Core Count
    The number of cores that should be mapped to the virtual machine.

Memory (GB)
    The amount of RAM that should be allocated to the virtual machine.

Host devices to passthrough
    Use this option to select PCI devices that are available to be mapped to
    guest virtual machine. For a PCI device to be listed here, it must be
    configured to use the :code:`pci-stub` Kernel driver. This process is documented
    in detail `here
    <https://faros.dev/https://faros.dev/installation.html#prepare-pci-passthrough-devices>`.

Host drives to passthrough
    Drives that are not currently mounted anywhere on the bastion will be
    listed here. Select them to mount them into the guest node as SCSI devices.

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

Network Proxy Configuration
---------------------------

If a network proxy must be used in order to access the internet for
installation, a seperate config TUI is available to provide the proxy settings.
When the proxy settings are configured, they will be used on the bastion node
to pull sources as well as configured on the OpenShift cluster.

.. code-block:: bash

   farosctl config proxy

Proxy Configuration
+++++++++++++++++++

Setup Cluster Proxy
    A boolean setting to control if the proxy settings should be deployed.

HTTP Proxy
    The URL to the HTTP proxy in the format :code:`PROTOCOL://USER:PASS@FQDN:PORT`

HTTPS Proxy
    The URL to the HTTPS proxy in the format :code:`PROTOCOL://USER:PASS@FQDN:PORT`

No Proxy Destinations
    The IP spaces and domains that should not be filtered through the proxy.

Additional CA Bundle
    If the proxy inspects HTTPS traffic, its CA Bundle must be uploaded to the
    cluster during install so that HTTPS traffic will still be trusted. These
    public certs should be pasted here.

Faros stores stateful configurations made above in `~/.config/faros/default` for
reference or backup.
