```
 _____ _     _   __________  ___
/  ___| |   | | | | ___ \  \/  |
\ `--.| |   | | | | |_/ / .  . |
 `--. \ |   | | | |    /| |\/| |
/\__/ / |___| |_| | |\ \| |  | |
\____/\_____/\___/\_| \_\_|  |_/

```
# Table of Contents

1. [Description](#description)
2. [Structure] (#structure)
3. [Usage](#usage)
    * [Requirements](#requirements-for-usage-at-cern)
    * [Beginning with slurm](#beginning-with-slurm)
5. [Reference - An under-the-hood peek at what the module is doing and how](#references)
    * [What slurm affects](#what-slurm-affects)
    * [Class references] (#class-references)
6. [Limitations](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Contributors](#contributors)
9. [Credits] (#credits)

# Description

This module installs the SLURM scheduler for running parallel programs on an HPC cluster.

This module sets up, configures and installs all required binaries and configuration files. All the configuration parameters come from Hiera data, and therefore actual class parameters have been kept to a bare minimum.
Jump [here](#beginning-with-slurm) for a quickstart. 

This module supports and has been tested on Redhat-based systems and works out of the box on CentOS 7. Patches for other distributions are welcome.

# Structure

The module's class structure is described next. This is useful for the user to know which parameters go where in the class namespace.

Please note that since this module supports over 300 parameters, these have not been arranged in the traditional fashion of having init.pp take all parameters and have them trickle down the hierarchy, but the parameters to each class has to be set through Hiera.

- The main class *slurm* `::slurm` only takes one parameter, `node_type`, which maps to the node's role in the slurm cluster. This value can be either `head`, `worker`, `db`, `db-head` (for db+head) or `none`.
  - The *setup* `slurm::setup` class contains common packages, directories, user names, uid and guid that are necessary before the actual installation and configuration.
  - The *config* class `slurm::config` holds all the parameters available for various configuration files, mostly slurm.conf and plugstack.conf. All the parameter names map to those of the slurm documentation. This class also takes care of installing and configuring munge depending on the authentication method parameter.
  - The configuration parameters for [cgroups], [network topology] and [accounting metrics gathering] must be set through Hiera by addressing their corresponding namespace (e.g. `slurm::config::task_affinity: 'yes'`).
  - There are also role-specific config and setup classes; e.g. slurm::dbnode::config, slurm::workernode::setup. These contain role-specific parameters that can also be set through Hiera. These classes will take care of setting up and configuring necessary services for each role. Most notably, slurm::dbnode::config holds the configuration parameters for slurmddb.conf. 


# Usage 

## Notes for RHEL/CentOS users

The Slurm packages provided by EPEL may have certain packages renamed. This Slurm puppet module follows the upstream nomenclature and assumes the upstream specfile has been used to generate packages.

## Requirements for usage at CERN

This package should provide everything necessary for most SLURM deployments.

If you use this module at CERN, it needs to be enabled in the pluginsync filter :
```yaml
# my_hostgroup.yaml

# enabling the slurm module
pluginsync_filter:
 - slurm

```

## Beginning with slurm

This Section provides examples for a minimal configuration to get started with a basic setup.

To use the module, first include it in your hostgroup manifest :
```ruby
# my_hostgroup.pp

# including slurm to be able to do some awesome scheduling on HPC machines
include ::slurm

# Put my secret mungekey on all the machine for the MUNGE security plugin
# You can generate the content using `dd if=/dev/random bs=1 count=1024 >/etc/munge/munge.key`
file { '/etc/munge/munge.key':
  ensure  => file,
  content => 'YourIncrediblyStrongSymmetricKey',
  owner   => 'munge',
  group   => 'munge',
  mode    => '0400',
}

```
and then make sure you have all the necessary configuration options in data; without any Hiera data, the module will *not* work, puppet will trigger a warning and nothing will be installed and/or configured.

The following minimal configuration is required for the module to work, i.e. you need a master controller, at least one workernode and a partition containing the nodes.
```yaml
# my_hostgroup.yaml

slurm::config::control_machine: slurm-master.yourdomain.com   # Only one controller is needed, backup is optional
slurm::config::plugin_dir: /usr/lib64/slurm                   # Path to your SLURM installation
slurm::config::open_firewall: true                            # Open the SLURM ports using the puppet firewall module

slurm::config::workernodes:
  -
    NodeName: slave[001-010]
    CPUs: 16
    RealMemory: 64000
    State: UNKNOWN

slurm::config::partitions:
  -
    PartitionName: Arena
    Nodes: ALL
    Default: YES
    State: UP
```

You also need to specify on the sub-hostgroups which type the node should be in the slurm configuration, e.g. head, worker or database node.
```yaml
# my_hostgroup/head.yaml

slurm::node_type: head
```

```yaml
# my_hostgroup/worker.yaml

slurm::node_type: worker
```


# References

## What slurm affects

### Packages installed by the module

To avoid version conflicts, the following packages will be installed/replaced by the module in its default setup. You can override those lists in the setup classes if some packages are unnecessary/missing for your configuration, e.g. slurm-auth-none, slurm-pam_slurm, etc...

#### On all types of nodes
```yaml
- 'slurm',
- 'slurm-devel',
- 'munge',
- 'munge-libs',
- 'munge-devel',
```

#### On the database nodes
```yaml
- 'slurm-slurmdbd',
```

#### On the headnodes
```yaml
- 'slurm-perlapi',
- 'slurm-torque',
```

#### On the worker nodes
```yaml
- 'slurm-perlapi',
- 'slurm-torque',
```

### Dependencies

#### Authentication
The default (and only supported) authentication mechanism for SLURM is [MUNGE](https://dun.github.io/munge/). It is set in the configuration file `slurm.conf` as follows:
```
AuthType=auth/munge
```
Another alternative for this value is `auth/none` which requires the `auth-none` plugin to be built as part of SLURM. It is recommended to use MUNGE rather than unauthenticated communication.

#### Database configuration

The database for SLURM is used solely for accounting purposes. The module supports a setup with a database node either separate (`slurm::node_type: 'db'`) from or combined with a headnode (`slurm::node_type: 'db-head'`). The database configuration is done in the [dbnode](manifests/dbnode) manifests.

The relevant accounting configuration values in [slurm.conf](#slurm.conf.erb) and [slurmdbd.conf](#slurmdbd.conf.erb) map to equally named parameters in slurm::dbnode::config and slurm::config. You should set `slurm::config::accounting_storage_type` to suit your preferences. It is set to `accounting_storage/none` by default, and in this case no database configuration is required.

Further information can be found in the [official documentation](https://slurm.schedmd.com/accounting.html).


### Version

Currently, the module is configured to match versions 17.02.X. It has been tested and works with version 17.02.6, and installation defaults to this version.

## Class references
### slurm
```ruby
class slurm (
  Enum['worker','head','db','db-head','none'] $node_type,
)
```
The main class is responsible for calling the relevant node type classes according to node_type parameter or to warn the user that he did not specify any node type.


### slurm::setup
```ruby
class slurm::setup (
  String $slurm_version = '17.02.6',
  Integer[0] $slurm_gid = 950,
  Integer[0] $slurm_uid = 950,
  String $slurm_home_loc = '/usr/local/slurm',
  String $slurm_log_file = '/var/log/slurm',
  String $slurm_plugstack_loc = '/etc/slurm/plugstack.conf.d',
)
```
The setup class, common to all types of nodes, is responsible for setting up all the folders and keys needed by SLURM to work correctly. For more details about each parameter, please refer to the header of [setup.pp](manifest/setup.pp).


### slurm::config

The configuration class, common to all types of nodes, is responsible for creating the main slurm.conf configuration file. For more details about each parameter, please refer to the [SLURM documentation](https://slurm.schedmd.com/slurm.conf.html). This class holds over 200 parameters, and the names of the class parameters map to the names of the SLURM configuration file parameters. Mostly slurm.conf and plugstack.conf. Almost all default values are taken from SLURM's official documentation, except the control_machine, the workernodes and the partitions; these are mandatory values that must be provided by the user.

#### slurm::config::configless

When true, only headnodes will have config files written under /etc/slurm. Other nodes are expected to be configured to launch slurmd with --conf-server $HEADNODE.
Additionally, it will automatically add enable_configless to the slurmctld_parameters.

#### slurm::config::acct_gather
```ruby
class slurm::config::acct_gather ()
```
The acct_gather class is responsible for creating the configuration file used by the AcctGather type plugins, namely EnergyIPMI, ProfileHDF5 and InfinibandOFED. Details about the parameters can be found on the [dedicated page](https://slurm.schedmd.com/acct_gather.conf.html) in the SLURM documentation.


#### slurm::config::cgroup
```ruby
class slurm::config::cgroup ()
```
The cgroup class is responsible for creating the configuration file used by all the plugins using cgroups, namely proctrack/cgroup, task/cgroup and jobacct_gather/cgroup. Details about the parameters can be found on the [dedicated page](https://slurm.schedmd.com/cgroup.conf.html) in the SLURM documentation.

#### slurm::config::topology
```ruby
class slurm::config::topology (
  Array[Hash[String, String]] $switches,
)
```
The topology class is responsible for creating the configuration file used by all the plugins using topology, namely topology/tree and route/topology. It expects an array of hashes, where each hash represents the key-values of one line of slurm's topology.conf file.
Details about the parameters can be found on the [dedicated page](https://slurm.schedmd.com/topology.conf.html) in the SLURM documentation.

### slurm::dbnode
```ruby
class slurm::dbnode ()
```
The database class is responsible for calling the database specific setup and configuring class.

#### slurm::dbnode::setup
```ruby
class slurm::dbnode::setup ()
```
The database setup class is responsible for installing the necessary packages and creating all the necessary folders and files for the dbnode to work.

#### slurm::dbnode::config

The database configuration class is responsible for creating the configuration file for the dbnode and starting the slurmdbd daemon. The slurmdbd.conf configuration parameteres go there.

### slurm::headnode
```ruby
class slurm::headnode ()
```
The headnode class is responsible for calling the headnode specific setup and configuring classes.


#### slurm::headnode::setup
```ruby
class slurm::headnode::setup ()
```
The headnode setup class is responsible for installing the necessary packages and creating all the necessary folders and files for the headnode to work.


#### slurm::headnode::config
```ruby
class slurm::headnode::config ()
```
The headnode configuration class is responsible for starting the slurmctld daemon.


### slurm::workernode
```ruby
class slurm::workernode ()
```
The workernode class is responsible for calling the workernode specific setup and configure class.


#### slurm::workernode::setup
```ruby
class slurm::workernode::setup ()
```
The workernode setup class is responsible for installing the necessary packages and creating all the necessary folders and files for the workernode to work.


#### slurm::workernode::config
```ruby
class slurm::workernode::config ()
```
The workernode configuration class is responsible for starting the slurmd daemon.



### Files

#### acct_gather.conf.erb
Slurm configuration file for the acct_gather plugins. More details in the [acct_gather.conf documentation](https://slurm.schedmd.com/acct_gather.conf.html).

#### cgroup.conf.erb
Slurm configuration file for the cgroup support. More details in the [cgroup.conf documentation](https://slurm.schedmd.com/cgroup.conf.html).

#### plugstack.conf.erb
Slurm configuration file for SPANK plugins. More details in the [SPANK documentation](https://slurm.schedmd.com/spank.html).

#### slurm.conf.erb
Slurm configuration file, common to all the nodes in the cluster. More details in the [slurm.conf documentation](https://slurm.schedmd.com/slurm.conf.html).

#### slurmdbd.conf.erb
Slurm Database Daemon (SlurmDBD) configuration file. More details in the [slurmdbd.conf documentation](https://slurm.schedmd.com/slurmdbd.conf.html).

#### topology.conf.erb
Slurm configuration file for defining the network topology. More details in the [topology.conf documentation](https://slurm.schedmd.com/topology.conf.html).

# Limitations

It has been tested and works on Centos 7.3 with Puppet 4.9.4.


# Development

The future task which needs to be done is testing any new versions of SLURM and checking if the current module still supports the latest features.

As always, changes should be done in a new branch first for testing and then a merged to qa using a merge request. Once the module is validated in qa for at least one week, the changes can be merged into master.

Please document all changes in the CHANGELOG and update this README if necessary!

# Contributors

  * Philippe Ganz (CERN) as creator and main maintainer
  * Carolina Lindqvist (CERN) as creator and main maintainer
  * Pablo Llopis (CERN) as main maintainer

# Credits

  * The dirtree function `dirtree.rb` was incorporated from https://github.com/puppetlabs/pltraining-dirtree
