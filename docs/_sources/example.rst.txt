Verified Implimentation
=======================

.. figure:: _images/example/portrait.jpg
    :align: center

    Fedora for scale

Hardware specifications
-----------------------

The HPE EL8000 makes a great hardware platform for Faros deployed OpenShift
clusters. A single, 5U, half-width chassis can four blades that can all be
equipped with 2xSSDs, 4xNVMEs, and 1xGPU. Additionally, the chassis includes
one 1gbe integrated switch and up to two 10gbe switches. This allows most of
the wiring to stay internal to the chassis.

The cluster used as a reference platform has the following specifications:

    +-------------------+---------------------------------------+
    | Blades            | 4x server blades                      |
    +-------------------+---------------------------------------+
    | CPU (per blade)   | 24 core 2.4 GHz Intel proc            |
    +-------------------+---------------------------------------+
    | vCPU (per blade)  | 48 vCPUs (with HT enabled)            |
    +-------------------+---------------------------------------+
    | RAM (per blade)   | 192 GB                                |
    +-------------------+---------------------------------------+
    | GPU (per blade)   | NVIDIA T4 (coming soon) (not bastion) |
    +-------------------+---------------------------------------+
    | SSD (per blade)   | 2x 256GB SSD                          |
    +-------------------+---------------------------------------+
    | NVME (per blade)  | 4x 2TB NVME                           |
    +-------------------+---------------------------------------+

Chassis wiring
--------------

As mentioned, the integrated switches on the EL8000 are used extensively to
minimize external wiring. In total, the example implementation here uses 3
network cables. The first network cable connects to the WAN port on the bastion
node. The second connects the bastion node to a wireless access point for local
network access. The third cable bridges the integrated 1g switch and the
integrated management switch.

Because the 1gbe and 10gbe integrated switches are used, by default every
cluster node will have two network connections (in addition to their management
connections) to the cluster network. This is not ideal as it cannot be
guaranteed which interface will be used by OpenShift, and one is substantially
slower than the other. To prevent issues, the 1gbe links on all of the cluster
nodes will be added to the ignore list.

The following diagram shows the logical network layout. Note that black lines
indicate physical connections that are not integrated into the chassis.

.. figure:: _images/example/wiring.svg
    :align: center

    Logical wiring diagram

For reference, the following image shows the physical chassis wiring with WAN
connection, wireless access point, 1gbe switch bridge, and power. It is
difficult to see the 1gbe switch bridging cable. It is a 6 inch black ethernet
cable on the bottom right of the chassis.

.. figure:: _images/example/wiring.jpg
    :align: center

    Physical cluster wiring


OpenShift cluster configuration
-------------------------------

The following values were used for the verified Faros deployment.

Router Configuration
++++++++++++++++++++

:LAN Interfaces: `['eno1', 'eno2', 'eno3', 'eno4', 'eno5']`
:Subnet: `192.168.8.0`
:Subnet Mask: `24`
:Premitted Ingress Traffic: `['SSH to Bastion', 'HTTPS to Cluster API', 'HTTP to Cluster Apps', 'HTTPS to Cluster Apps']`

Cluster Configuration
+++++++++++++++++++++

:Administrator Password: `**********`
:Pull Secret: `**********`

Host Record Configuration
+++++++++++++++++++++++++

:Machine Management Provider: `ilo`
:Machine Management User: `Administrator`
:Machine Management Password: `**********`
:Bastion Node Management MAC Address: `ff:ff:ff:ff:ff:ff`
:Control Plane Machines:
    - :Node Name: `node-0`
      :MAC Address: `ff:ff:ff:ff:ff:ff`
      :Management MAC Address: `ff:ff:ff:ff:ff:ff`
    - :Node Name: `node-1`
      :MAC Address: `ff:ff:ff:ff:ff:ff`
      :Management MAC Address: `ff:ff:ff:ff:ff:ff`
    - :Node Name: `node-2`
      :MAC Address: `ff:ff:ff:ff:ff:ff`
      :Management MAC Address: `ff:ff:ff:ff:ff:ff`

Extra DNS/DHCP Records
++++++++++++++++++++++

:Extra Records:
    - :Node Name: `chassis`
      :MAC Address: `ff:ff:ff:ff:ff:ff`
    - :Node Name: `wifi`
      :MAC Address: `ff:ff:ff:ff:ff:ff`
:Ignored MAC Addresses:
    - :Entry Name: `node-0-1g`
      :MAC Address: `ff:ff:ff:ff:ff:ff`
    - :Entry Name: `node-1-1g`
      :MAC Address: `ff:ff:ff:ff:ff:ff`
    - :Entry Name: `node-2-1g`
      :MAC Address: `ff:ff:ff:ff:ff:ff`
