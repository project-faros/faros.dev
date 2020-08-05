:github_url: https://github.com/project-faros/faros.dev/blob/master/source/installation.rst

Faros Installation
==================

The Faros reference architecture is deployed by the Faros Cluster Manger. The
cluster manager is controlled via a cli interface called `farosctl`. This CLI
only needs to be installed on the bastion node.

Prepare the bastion node
------------------------

The first action is to prepare the bastion node by installing RHEL 8 onto it.
In theory, CentOS 8 should also work, but it is not tested. During install, the
following details are important.

  - Configure only the WAN link on the bastion node. It may be either a bonded
    interface or a single interface.
  - Statically configure the bastion node's DNS name using the scheme discussed
    before: :code:`bastion.CLUSTER_NAME.CLUSTER_DOMAIN`.
  - It is recomended to install the `RHEL Server without GUI` set of packages.
    In theory, any option that includes additional packages should also work.
  - The primary drive used to install RHEL on the bastion node is the same
    drive that will be used on all of the cluster nodes for RHCOS. Primary is
    defined as the drive that contains the :code:`/boot` partition.
  - During install, it is best to setup a single user account that will be used
    for the cluster deployment. This user account should be an admin account
    with the ability to sudo.
  - It is not recomended to set a root password. It is best practice to not
    allow root to log in directly.

Once the bastion node's operating system is installed and the node has
rebooted, attach the Red Hat system to RHSM and update the operating system to
the latest set of patches. Reboot the system.

Install the CLI
---------------

To install the Faros tooling and dependencies, as the administrative user, run
the following command::

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/project-faros/farosctl/master/bin/bootstrap_bastion.sh)"

This command will request the user's password to enable sudo access. The
command requires sudo in order to `dnf install` dependencies, configure
SELinux, enable cockpit.
