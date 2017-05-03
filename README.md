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
2. [Setup - The basics of getting started with slurm](#setup)
    * [What slurm affects](#what-slurm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with slurm](#beginning-with-slurm)
3. [Usage](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors](#contributors)

# Description

This module installs the SLURM scheduler for running parallel programs on an HPC cluster.

It sets up, configures and installs all required binaries and configuration files according to the parameters shown [below](#beginning-with-slurm). It relies on hiera data provided by the hostgroup it is included in.

# Setup

## What slurm affects

### Packages installed by the module

To avoid version conflicts, all the following packages will be installed/replaced by the module :

#### On all type of nodes
```
 - 'slurm',
 - 'slurm-devel',
 - 'slurm-munge',
 - 'munge',
 - 'munge-libs',
 - 'munge-devel',
```

#### On the database nodes
```
 - 'slurm-plugins',
 - 'slurm-slurmdbd',
 - 'slurm-sql',
```

#### On the headnodes
```
 - 'slurm-auth-none',
 - 'slurm-perlapi',
 - 'slurm-plugins',
 - 'slurm-torque',
```

#### On the worker nodes
```
 - 'slurm-auth-none',
 - 'slurm-perlapi',
 - 'slurm-plugins',
 - 'slurm-torque',
```

### Dependencies

#### Authentication
The default (and only supported) authentication mechanism for SLURM is [MUNGE](https://dun.github.io/munge/). It is set in the configuration file `slurm.conf` as follows:
```
AuthType=auth/munge
```
Other alternatives for this value is `auth/none` which requires the `auth-none` plugin to be built as part of SLURM. It is recommended to use MUNGE rather than unauthenticated communication.

<!---
#### Checkpointing
This feature is currently not available since the main project, i.e. BLCR, has been discontinued since 2013. We are investigating alternatives like DMTCP, SCR and OpenMPI's build it checkpointing mechanism.
--->

#### Database configuration
The database for SLURM is used solely for accounting purposes. The module supports a setup with a database node either separate from or combined with a headnode. The database configuration is done in the [dbnode](manifests/dbnode) manifests.

The main configuration values (as defined in [slurm.conf](#slurm.conf.erb) and [slurmdbd.conf](#slurmdbd.conf.erb) for the database are the following:
```
# class slurm::config
String $accounting_storage_host     = 'accountingdb.example.org',                 # DB node hostname
String $accounting_storage_loc      = 'slurm_acct_db',                            # DB name (inside the MySQL DB)
String $accounting_storage_pass     = '/var/run/munge/munge.socket.2',            # DB authentication (password or munge)
Integer $accounting_storage_port    = 6819,                                       # DB node port
String $accounting_storage_type     = 'accounting_storage/none',                  # Type of storage (none, filetext, mysql, slurmdbd)
String $accounting_storage_user     = 'slurm',                                    #
String $cluster_name                = 'mycluster',                                #
String $job_acct_gather_frequency   = 'task=30,energy=0,network=0,filesystem=0',  # Accounting sampling interval
String $job_acct_gather_type        = 'jobacct_gather/none',                      # Accounting mechanism (none or linux)
String $acct_gather_energy_type     = 'acct_gather_energy/none',                  # Energy accounting plugin (none, ipmi, rapl)
String $acct_gather_infiniband_type = 'acct_gather_infiniband/none',              # Infiniband accounting plugin (none, ofed)
String $acct_gather_filesystem_type = 'acct_gather_filesystem/none',              # Filesystem accounting plugin (none, lustre)
String $acct_gather_profile_type    = 'acct_gather_profile/none',                 # Job profiling plugin (none, hdfs5)

# class slurm::dbnode::config
String $dbd_host      = 'localhost',                                              # DB node hostname (either headnode or dbnode hostname. Preferably `localhost`.)
Integer $dbd_port     = 6819,                                                     # DB node port
String $slurm_user    = 'slurm',                                                  #
String $storage_host  = 'db_instance.example.org',                                # Hostname of the node where MySQL instance is running
Integer $storage_port = 1234,                                                     # MySQL instance port number
String $storage_user  = 'user',                                                   #
String $storage_loc   = 'accountingdb',                                           # DB name (inside the MySQL DB)
```

If the database is running on a headnode, and locally, the hostnames can be set as `localhost`.
Further information can be found in the [official documentation](https://slurm.schedmd.com/accounting.html).


## Setup requirements

If you use this module at CERN, it needs to be enabled in the pluginsync filter :
```
# my_hostgroup.yaml

...

# enabling the slurm module
pluginsync_filter:
 - slurm

...
```

## Beginning with slurm

To use the module, first include it in your hostgroup manifest :
```
# my_hostgroup.pp

...

# including slurm to be able to do some awesome scheduling on HPC machines
  include 'slurm'

...
```

and then make sure you have all the necessary configuration options in data; without any data, the module will *not* work, puppet will trigger an error and nothing will be installed.

The following minimal configuration is required for the module to work
```
# my_hostgroup.yaml

slurm::config::control_machine: slurm-master.yourdomain.com
slurm::config::backup_controller: slurm-2IC.yourdomain.com

slurm::config::workernodes:
  -
    NodeName: slave[001-010]
    CPUs: 32
    CoresPerSocket: 8
    Sockets: 2
    ThreadsPerCore: 2
    RealMemory: 128000
    State: UNKNOWN

slurm::config::partitions:
  -
    PartitionName: Arena
    Nodes: ALL
    Default: YES
    DefMemPerCPU: 4000
    MaxMemPerCPU: 4000
    DefaultTime: 'UNLIMITED'
    State: UP
...
```

# Usage

Please refer to the official [SLURM documentation](https://slurm.schedmd.com/).

# References

## slurm
```
class slurm (
  String $node_type = '',
)
```
This is the main class which switches through the type classes according to node_type parameter.

## slurm::setup
```
class slurm::setup (
  Integer $slurm_gid          = 950,
  Integer $slurm_uid          = 950,
  String $slurm_home_loc      = '/usr/local/slurm',
  String $slurm_log_file      = '/var/log/slurm',
  String $slurm_plugstack_loc = '/etc/slurm/plugstack.conf.d',
  String $slurm_private_key   = 'slurmkey',
  String $slurm_public_key    = 'slurmcert',
  Integer $munge_gid          = 951,
  Integer $munge_uid          = 951,
  String $munge_loc           = '/etc/munge',
  String $munge_log_file      = '/var/log/munge',
  String $munge_home_loc      = '/var/lib/munge',
  String $munge_run_loc       = '/run/munge',
  String $munge_shared_key    = 'mungekey',
  Array $packages = [
    'slurm',
    'slurm-devel',
    'slurm-munge',
    'munge',
    'munge-libs',
    'munge-devel',
  ],
)
```

This is the setup class, common to all types of nodes, which sets up all the folders and keys needed by SLURM to work correctly. For more details about each parameter, please refer to the header of [setup.pp](manifest/setup.pp).

## slurm::config
```
class slurm::config (
  String $control_machine                   = 'headnode1.example.org',
  String $backup_controller                 = 'headnode2.example.org',
  String $auth_type                         = 'auth/munge',
  String $checkpoint_type                   = 'checkpoint/none',
  String $crypto_type                       = 'crypto/munge',
  String $job_checkpoint_dir                = '/var/slurm/checkpoint',
  String $job_credential_private_key        = '/usr/local/slurm/credentials/slurm.key',
  String $job_credential_public_certificate = '/usr/local/slurm/credentials/slurm.cert',
  Integer $max_tasks_per_node               = 32,
  String $mpi_default                       = 'pmi2',
  Integer $max_job_count                    = 5000,
  String $plugin_dir                        = '/usr/lib64/slurm',
  String $plug_stack_config                 = '/etc/slurm/plugstack.conf',
  String $private_data                      = 'cloud',
  String $proctrack_type                    = 'proctrack/pgid',
  Integer $slurmctld_port                   = 6817,
  Integer $slurmd_port                      = 6818,
  String $slurmd_spool_dir                  = '/var/spool/slurmd',
  String $state_save_location               = '/var/spool/slurmctld/slurm.state',
  String $task_plugin                       = 'task/none',
  String $task_plugin_param                 = 'Sched',
  String $topology_plugin                   = 'topology/none',
  Integer $tree_width                       = 50,
  String $unkillable_step_program           = '/usr/bin/echo',
  Integer $def_mem_per_cpu                  = 4000,
  String $scheduler_type                    = 'sched/backfill',
  String $select_type                       = 'select/cons_res',
  String $select_type_parameters            = 'CR_CPU_Memory',
  String $priority_type                     = 'priority/basic',
  String $priority_flags                    = 'SMALL_RELATIVE_TO_TIME',
  Integer $priority_calc_period             = 5,
  String $priority_decay_half_life          = '7-0',
  String $priority_favor_small              = 'NO',
  String $priority_max_age                  = '7-0',
  String $priority_usage_reset_period       = 'NONE',
  Integer $priority_weight_age              = 0,
  Integer $priority_weight_fairshare        = 0,
  Integer $priority_weight_job_size         = 0,
  Integer $priority_weight_partition        = 0,
  Integer $priority_weight_qos              = 0,
  String $priority_weight_tres              = 'CPU=0,Mem=0',
  String $slurm_user                        = 'slurm',
  String $accounting_storage_host           = 'accountingdb.example.org',
  String $accounting_storage_loc            = 'slurm_acct_db',
  String $accounting_storage_pass           = '/var/run/munge/munge.socket.2',
  Integer $accounting_storage_port          = 6819,
  String $accounting_storage_type           = 'accounting_storage/none',
  String $accounting_storage_user           = 'slurm',
  String $cluster_name                      = 'mycluster',
  String $job_acct_gather_frequency         = 'task=30,energy=0,network=0,filesystem=0',
  String $job_acct_gather_type              = 'jobacct_gather/none',
  String $acct_gather_energy_type           = 'acct_gather_energy/none',
  String $acct_gather_infiniband_type       = 'acct_gather_infiniband/none',
  String $acct_gather_filesystem_type       = 'acct_gather_filesystem/none',
  String $acct_gather_profile_type          = 'acct_gather_profile/none',
  String $slurmctld_debug                   = 'info',
  String $slurmctld_log_file                = '/var/log/slurm/slurmctld.log',
  String $slurmd_debug                      = 'info',
  String $slurmd_log_file                   = '/var/log/slurm/slurmd.log',
  Array $workernodes = [{
    'NodeName' => 'worker[00-10]',
    'CPUs' => '16',
  }],
  Array $partitions = [{
    'PartitionName' => 'workers',
    'MaxMemPerCPU' => '2000',
  }],
  Array $switches = [{
    'SwitchName' => 's0',
    'Nodes' => 'worker[00-10]',
  }],
)
```
This is the configuration class, common to all types of nodes, which creates the main slurm.conf configuration file and all the files needed by the different plugins. For more details about each parameter, please refer to the header of [config.pp](manifest/config.pp).

## slurm::dbnode
```
class slurm::dbnode ()
```
Setup, configure and install the dbnode.


### slurm::dbnode::setup
```
class slurm::dbnode::setup (
  String $slurmdbd_log_file  = '/var/log/slurm/slurmdbd.log',
  Array $packages = [
    'slurm-plugins',
    'slurm-slurmdbd',
    'slurm-sql',
  ],
)
```
Setup the dbnode.


### slurm::dbnode::config
```
class slurm::dbnode::config (
  String $dbd_host      = 'localhost',
  Integer $dbd_port     = $slurm::config::accounting_storage_port,
  String $slurm_user    = $slurm::config::slurm_user,
  String $storage_host  = 'db_instance.example.org',
  Integer $storage_port = 1234,
  String $storage_user  = 'user',
  String $storage_loc   = 'accountingdb',
)
```
Configure the dbnode.

### slurm::dbnode::firewall
```
class slurm::dbnode::firewall (
  Integer $accounting_storage_port = $slurm::config::accounting_storage_port,
)
```
Define the port used for DB communication on the DB node.


## slurm::headnode
```
class slurm::headnode ()
```
Setup, configure and install the headnode.


### slurm::headnode::setup
```
class slurm::headnode::setup (
  String $slurmctld_spool_dir = '/var/spool/slurmctld',
  String $state_save_location = '/var/spool/slurmctld/slurm.state',
  String $slurmctld_log_file  = '/var/log/slurm/slurmctld.log',
  Array $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-torque',
  ],
)
```
Setup the headnode.


### slurm::headnode::config
```
class slurm::headnode::config ()
```
Configure the headnode.

### slurm::headnode::firewall
```
class slurm::headnode::firewall (
  Integer $slurmctld_port = $slurm::config::slurmctld_port,
)
```
Setup the firewall for the headnode.


## slurm::workernode
```
class slurm::workernode ()
```
Setup, configure and installs the workernode.


### slurm::workernode::setup
```
class slurm::workernode::setup (
  String $slurmd_spool_dir = '/var/spool/slurmd',
  String $slurmd_log_file  = '/var/log/slurm/slurmd.log',
  Array $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-torque',
  ],
)
```
Setup the workernode.


### slurm::workernode::config
```
class slurm::workernode::config ()
```
Configure the workernode.

### slurm::workernode::firewall
```
class slurm::workernode::firewall (
  Integer $slurmd_port = $slurm::config::slurmd_port,
)
```
Setup the firewall for the workernode.

## Files

### acct_gather.conf.erb
TODO

### cgroup.conf.erb
TODO

### job_stuck_alert.sh.erb
TODO

### plugstack.conf.erb
TODO

### slurm.conf.erb
TODO

### slurmdbd.conf.erb
TODO

### topology.conf.erb
TODO

# Limitations

It is tested and working on Centos 7.2/7.3 with Puppet 4.8.1. Not working with Puppet 3!


# Development

The future task which needs to be done is testing any new versions of SLURM and checking if the current module still supports the latest features.

As always, changes should be done in a new branch first for testing and then a merged to qa using a merge request. Once the module is validated in qa for at least one week, the changes can be merged into master.

Please document all changes in the CHANGELOG and update this README if necessary!

# Contributors

  * Philippe Ganz (CERN) as creator and main maintainer
  * Carolina Lindqvist (CERN) as creator and main maintainer
