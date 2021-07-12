:github_url: https://github.com/project-faros/faros.dev/blob/master/source/farosctl.rst

farosctl Usage
==============

:code:`farosctl COMMAND [OPTIONS]`

The farosctl command is responsible for configuring the bastion node/router,
configuring the OpenShift cluster, and performing some day 2 operations on the
cluster.

Commands
++++++++

The following commands are available.

dir
---

:code:`farosctl dir`

Print the directory used for storing the cluster configuration.

extract
-------

:code:`farosctl extract SOURCE DEST`

Search for the :code:`SOURCE` file in the binary and export it to :code:`DEST`
on the host. This is useful for extracting new versions of the `oc` or
`farosctl` commands.

**Example**
    :code:`farosctl extract oc ~/bin/oc`

help
----

:code:`farosctl [SUBCOMMAND] help`

Print help documentation.

shell
-----

:code:`farosctl shell`

Launch a farosctl managment shell. Useful for debugging issues.

update
------

:code:`farosctl update`

Update faros to the newest version.

apply
-----

:code:`farosctl apply [SUBCOMMAND] [FLAGS]`

Apply commands are idempotent and safe to run at any time, even after the
cluster has been created.

**Subcommands**
    :all: *[DEFAULT]* Apply all configuration
    :host-records: Apply DNS and DHCP reservations
    :router: Apply the network routing and firewall configuration

**Example**
    :code:`farosctl apply host-records`

config
------

:code:`farosctl config [SUBCOMMAND]`

Launch the configuration TUIs to set the parameters that control the final
cluster behavior.

**Subcommands**
    :all: *[DEFAULT]* Configure only the main cluster settings
    :cluster: Configure only the main cluster settings
    :proxy: Configure proxy settings required to reach the internet

**Example**
    :code:`farosctl config`


create
------

:code:`farosctl create SUBCOMMAND [FLAGS]`

Create commands are not to be considered idempotent and should (generally) not
be run after the cluster has been created. These commands are potentially
destructive actions that are taken in order to create the initial cluster.

**Subcommands**
    :cluster: Perform the final step of install OpenShift
    :install-repos: Create the internal sources for the RHCOS images and Ignition
                    files
    :load-balancer: Create the cluster load balancer
    :machines: Create any virtual machines required for install (eg: Bootstrap
            node)

**Example**
    :code:`farosctl create install-repos`

deploy
------

:code:`farosctl deploy SUBCOMMAND [FLAGS]`

Deploy commands are generally run after the cluster has been created and are
responsible for adding services to the OpenShift cluster and performing
post-install configuration of the cluster.

**Subcommands**
    :container-storage: Deploy OpenShift Container Storage
    :hosted-loadbalancer: *[EXPERIMENTAL]* Deploy the cluster load balancer as a
                          service on the cluster
    :nvidia-drivers: Deploy NVIDIA operator to install drivers on cluster
                     nodes.
    :odh-demo: Deploy an example Open Data Hub workflow
    :redhat-entitlements: Deploy entitlement certificates to the cluster nodes
                          to allow the cluster to build UBI images.
    :wipefs: Wipe the filesystem of select drives on select nodes

**Example**
    :code:`farosctl deploy container-storage`

destroy
-------

:code:`farosctl destroy SUBCOMMAND [FLAGS]`

Destroy various resouces that are created during the Faros deployment. These
actions are extremely destructive and should be done with care.

**Subcommands**
    :all: *[DEFAULT]* Run all of the destroy steps in order
    :cluster: Destroy the deployed OpenShift cluster and wipe the node disks
    :install-repos: Clean all local content repositories with OS images and
                     configs.
    :load-balancer: Remove the load balancer the fronts the OpenShift cluster

**Example**
    :code:`farosctl destroy cluster`

get
---

:code:`farosctl get SUBCOMMAND [FLAGS]`

These commands return information about the cluster for convenience.

**Subcommands**
    :cluster-upgrade-status: Show the overall cluster status and health
    :credentials: Return the URLs and passwords required to login to the cluster
    :ip-addresses: Display a table of all IP addresses on the cluster network
                   that are known to the faros utility
    :oc-login: Returns the oc command used to login to the cluster
    :public-dns-records: Returns the DNS records that are required external to the
                        cluster

**Example**
    :code:`farosctl get credentials`

identify
--------

:code:`farosctl identify HOST_LIST`

Blink the identification light on the hosts specified via a comma seperated
list.

**Example**
    :code:`farosctl identify node-0`

install-plan
------------

:code:`farosctl install-plan SUBCOMMAND [FLAGS]`

Installation plans are a series of farosctl commands that are commonly run
together to accomplish a larger task.

**Subcommands**
    :cluster: Apply configuration, create machines, and do everything else required
            to make a cluster from scratch
    :nvidia-support: Ensure the cluster nodes are properly entitled and then
                     configure them to support NVIDIA GPUs.

**Example**
    :code:`farosctl install-plan cluster`

oc
--

:code:`farosctl oc [OC FLAGS AND ARGUMENTS]`

This command runs oc as the kubeadmin user with full cluster rights. This is
provided for convenience and some oc commands may not work properly (oc patch,
for example). It is recomended to login to the cluster natively from the
command line instead of relying on farosctl os.

**Example**
    :code:`farosctl oc get nodes`

poweroff / shutdown
-------------------

:code:`farosctl poweroff`
:code:`farosctl shutdown`

Safely shutdown the cluster.

force-poweroff / force-shutdown
-------------------------------

:code:`farosctl force-poweroff`

Poweroff the cluster without verifying the health of the cluster operators.

poweron / startup
-----------------

:code:`farosctl poweron`
:code:`farosctl startup`

Bring the cluster up.

ssh
---

:code:`farosctl ssh NODE_NAME`

Use SSH to make a connection to any of the nodes in the cluster. Use the
hostnames for the nodes, not the FQDN.

**Example**
    :code:`farosctl ssh node-0`

version
-------

:code:`farosctl version`

Print the version of the current farosctl code.

wait-for
--------

:code:`farosctl wait-for SUBCOMMAND [FLAGS]`

Wait for commands are designed to block the prompt until a condition is met.

**Subcommands**
    :firmware-config: Wait for the cluster node firmware configuration to be
                      manually verified by the user.
    :management-interfaces: Wait for the management interfaces on the cluster nodes
                            to come online with the expected IP addresses

**Example**
    :code:`farosctl wait-for management-interfaces`

Version pinning
+++++++++++++++

If it is desired to lock farosctl to a specific release, this can be easily
done by creating a symbolic link to the farosctl executable with the desired
version appended to the executable name.

For example, in order to pin to version 0.5.6:

.. code-block:: bash

   cd ~/bin
   ln -s farosctl farosctl.0.5.6
   farosctl.0.5.6 version

Even if an update is run, this link will always run the 0.5.6 release.

The same technique can also be used to run the latest development build of the
farosctl.

.. code-block:: bash

   cd ~/bin
   ln -s farosctl farosctl.dev
   farosctl.dev version
