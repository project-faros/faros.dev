:github_url: https://github.com/project-faros/faros.dev/blob/master/source/installation.rst

Faros Installation
==================

The Faros reference architecture is deployed by the Faros Cluster Manager. The
cluster manager is controlled via a cli interface called `farosctl`. This CLI
only needs to be installed on the bastion node.

Prepare the bastion node
------------------------

The first action is to prepare the bastion node by installing RHEL 8 onto it.
During install, the following details are important.

  - Configure only the WAN link on the bastion node. It may be either a bonded
    interface or a single interface.
  - Network interfaces must be configured using NetworkManager. Do not
    configure network interfaces with legacy ifcfg files as that will cause
    conflicts when the installer configures the networking on the machine.
  - Statically configure the bastion node's DNS name using the scheme discussed
    before: :code:`bastion.CLUSTER_NAME.CLUSTER_DOMAIN`.
  - It is recomended to install the `RHEL Server without GUI` set of packages.
    In theory, any option that includes additional packages should also work.
  - During install, it is best to setup a single user account that will be used
    for the cluster deployment. This user account should be an admin account
    with the ability to sudo.
  - It is not recomended to set a root password. It is best practice to not
    allow root to log in directly.
  - If FIPS mode is desired on the cluster, it should be manually enabled on
    the bastion node at install time.
  - It is **STRONGLY** recommended to encrypt all drives on the bastion node at
    install time. Any RHEL supported method may be used.

Once the bastion node's operating system is installed and the node has
rebooted, attach the Red Hat system to RHSM and update the operating system to
the latest set of patches. Reboot the system.

Prepare PCI Passthrough devices
-------------------------------

Some installations will require that certain PCI devices are passed through
from the bastion node to the guest node to be made available to the cluster. In
order to accomplish this, the PCI device must first be configured to use the
:code:`pci-stub` Kernel driver. This is a dummy driver that prevents the host
system from initializing the PCI device so that it will remain available to a
guest VM. This is configured by adding the following Kernel arguments to the
Grub configuration:

.. code::

  intel_iommu=on iommu=pt pci-stub.ids=VENDOR_ID:DEVICE_ID,....

For simplicity, the following code snippet will configure all NVIDIA device to
use the :code:`pci-stub` driver:

.. code::

  grubby --arg "intel_iommu=on iommu=pt pci-stub.ids=$(lspci -n | grep ':
  10de:' | awk '{ print $3; }' | xargs echo | tr ' ' ',')" --update-kernel ALL;
  grub2-mkconfig -o /etc/grub2.cfg; grub2-mkconfig -o /etc/grub2-efi.cfg

After this code has been run, reboot the machine and verify that the NVIDIA
devices are using the desired driver:

.. code::

  # lspci -kD -d 10de:
  0000:b1:00.0 3D controller: NVIDIA Corporation TU104GL [Tesla T4] (rev a1)
          Subsystem: NVIDIA Corporation Device 12a2
          Kernel driver in use: pci-stub
          Kernel modules: nouveau


Install the CLI
---------------

To install the Faros tooling and dependencies, as the administrative user (not
the root user), run the following command::

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/project-faros/farosctl/master/bin/bootstrap_bastion.sh)"

This command will request the user's password to enable sudo access. The
command requires sudo in order to `dnf install` dependencies, configure
SELinux, enable cockpit.
