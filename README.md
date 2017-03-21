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

### Specific packages

To avoid version conflicts, all the following packages will be installed/replaced by the module :

#### On all type of nodes
```
 - 'slurm',
 - 'slurm-devel',
 - 'slurm-munge',
 - 'munge-libs',
 - 'munge',
 - 'munge-devel',
```

#### On the headnodes
```
 - 'slurm-auth-none',
 - 'slurm-perlapi',
 - 'slurm-plugins',
 - 'slurm-torque',
```

#### On the database nodes
```
 - 'slurm-plugins',
 - 'slurm-slurmdbd',
 - 'slurm-sql',
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

Further configuration of MUNGE is done in [setup.pp](https://gitlab.cern.ch/ai/it-puppet-module-slurm/blob/master/code/manifests/setup.pp). The only required effort to set up MUNGE through the module is to generate a MUNGE secret key that is shared between nodes. For our setup, the key is stored in `tbag` as shown below.

```
[calindqv@aiadm16 slurm]$ tbag set --hg bi/hpc/batch mungekey --file munge.key
Adding key 'mungekey' to tbag for hostgroup 'bi/hpc/batch'
Key 'mungekey' successfully added to hostgroup 'bi/hpc/batch'
```

If you want to change the default tbag identifier (name) for the key, i.e. `mungekey`, or some other parameter for the `setup.pp` class, please make sure you add the corresponding variables in your hostgroups hieradata, e.g.:
```
# myhostgroup.yaml
slurm::setup::munge_key: mungekey
```

#### Secrets stored in Teigi (tbag)
The following secrets are stored using `tbag`. These are necessary for the SLURM module to work. Ensure that they have the same identifiers (names) or that the secrets have been renamed accordingly in the module.

```
[calindqv@aiadm18 ~]$ tbag showkeys --hg bi/hpc/batch
[
     "slurmkey",
     "slurmdbpass",
     "slurmcert",
     "mungekey"
]
```

#### Checkpointing
TODO Bla bla BLCR...

#### Database configuration
The database for SLURM is used solely for accounting purposes. The module supports a setup with a database node either separate from or combined with a headnode. The database configuration is done in the [dbnode](https://gitlab.cern.ch/ai/it-puppet-module-slurm/tree/master/code/manifests/dbnode) manifests.

The main configuration values (as defined in [slurm.conf](#slurm.conf.erb) and [slurmdbd.conf](#slurmdbd.conf.erb) for the database are the following:
```
# class slurm::config
accounting_storage_host = 'dbnode.example.org'
accounting_storage_loc  = 'accountingdb' # database name (inside the MySQL DB)
accounting_storage_port = '6819' # DB node port
accounting_storage_user = 'slurm'

# slurm.conf
AccountingStorageHost=dbnode.example.org ## DB node hostname (either headnode or dbnode hostname)
AccountingStoragePass=/var/run/munge/munge.socket.2
AccountingStoragePort=1234
AccountingStorageType=accounting_storage/slurmdbd

# class slurm::dbnode::config
accounting_storage_host   = 'dbnode.example.org' # DB node hostname (either headnode or dbnode hostname. Preferably `localhost`.)
accounting_storage_port   = '6819' # DB node port
slurm_user       = 'slurm'
storage_host         = 'db_instance.example.org' # Hostname of the node where MySQL instance is running.
storage_port         = '1234' # MySQL instance port number.
storage_user         = 'slurm'
storage_loc          = 'accountingdb' # database name (inside the MySQL DB)
slurmdbpass     = 'somethingsecret'

# slurmdbd.conf
StorageType=accounting_storage/mysql
StorageHost=db_instance.example.org
StoragePort=1234
StorageUser=slurm
StorageLoc=accountingdb
StoragePass=somethingsecret
```

If the database is running on a headnode, and locally, the hostnames can be set as `localhost`.
Further information can be found in the [official documentation](https://slurm.schedmd.com/accounting.html).

#### More Bla bla
TODO Bla bla


## Setup requirements

The module needs to be enabled in the pluginsync filter since it's not a standard CERN module :
```
# my_hostgroup.yaml

...

# enabling the slurm module
pluginsync_filter:
 - slurm

...
```

## Beginning with slurm

To use the module, simply include it in your hostgroup manifest :
```
# my_hostgroup.pp

...

# including slurm to be able to do some awesome scheduling on HPC machines
  include 'slurm'

...
```

### Hiera data details here.

# Usage

Please refer to the official [SLURM documentation](https://slurm.schedmd.com/).

TODO Specific usage at CERN ? Probably yes...
We can put examples and link to the KB here.

# References

## slurm
```
class slurm ()
```
TODO Bla bla

## slurm::setup
```
class slurm::setup (
  String $slurm_home_loc    = '/usr/local/slurm',
  String $slurm_log_file    = '/var/log/slurm',
  Integer $slurm_gid        = 950,
  Integer $slurm_uid        = 950,
  String $slurm_private_key = 'slurmkey',
  String $slurm_public_key  = 'slurmcert',
  Integer $munge_gid        = 951,
  Integer $munge_uid        = 951,
  String $munge_loc         = '/etc/munge',
  String $munge_log_file    = '/var/log/munge',
  String $munge_home_loc    = '/var/lib/munge',
  String $munge_run_loc     = '/run/munge',
  String $munge_shared_key  = 'mungekey',
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
TODO I do not want to do this one! :''(

## slurm::config
```
class slurm::config (
  String $control_machine                   = 'headnode1.example.org',
  String $backup_controller                 = 'headnode2.example.org',
  String $job_checkpoint_dir                = '/var/slurm/checkpoint',
  String $job_credential_private_key        = '/usr/local/slurm/credentials/slurm.key',
  String $job_credential_public_certificate = '/usr/local/slurm/credentials/slurm.cert',
  Integer $max_job_count                    = 5000,
  String $plugin_dir                        = '/usr/lib64/slurm',
  String $plug_stack_config                 = '/etc/slurm/plugstack.conf',
  Integer $slurmctld_port                   = 6817,
  Integer $slurmd_port                      = 6818,
  String $slurmd_spool_dir                  = '/var/spool/slurmd',
  String $state_save_location               = '/var/spool/slurmctld/slurm.state',
  String $slurm_user                        = 'slurm',
  String $accounting_storage_host           = 'accountingdb.example.org',
  String $accounting_storage_loc            = 'accountingdb',
  Integer $accounting_storage_port          = 6819,
  String $accounting_storage_user           = 'slurm',
  String $cluster_name                      = 'batch',
  String $slurmctld_log_file                = '/var/log/slurm/slurmctld.log',
  String $slurmd_log_file                   = '/var/log/slurm/slurmd.log',
  Array $workernodes = [{
    'NodeName' => 'worker[00-10]',
    'CPUs' => '16'
  }],
  Array $partitions = [{
    'PartitionName' => 'workers',
    'MaxMemPerCPU' => '2000'
  }],
)
```
Configuration class that defines values for the `slurm.conf` main configuration file. This file is described in detail [here](### slurm.conf.erb).

## slurm::dbnode
```
class slurm::dbnode ()
```
Setup, configure and install the dbnode.


### slurm::dbnode::setup
```
class slurm::dbnode::setup (
  String $job_accounting_log = '/var/log/slurm/slurm_jobacct.log',
  String $job_completion_log = '/var/log/slurm/slurm_jobcomp.log',
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
  String $dbd_host      = 'dbnode.example.org',
  Integer $dbd_port     = 6819,
  String $slurm_user    = 'slurm',
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
  Integer $accounting_storage_port = 6819,
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
  String $slurmctld_loc      = '/var/spool/slurmctld',
  String $slurm_state_loc    = '/var/spool/slurmctld/slurm.state',
  String $slurmctld_log_file = '/var/log/slurm/slurmctld.log',
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
  Integer $slurmctld_port = 6817,
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
  String $slurmd_loc      = '/var/spool/slurmd',
  String $slurmd_log_file = '/var/log/slurm/slurmd.log',
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
  Integer $slurmd_port = 6818,
)
```
Setup the firewall for the workernode.

## Files

### job_stuck_alert.sh
TODO Bla bla

### plugstack.conf
TODO Bla bla

## Templates

### acct_gather.conf.erb
TODO Bla bla

### slurm.conf.erb
TODO Bla bla

### slurmdbd.conf.erb
TODO Bla bla


# Limitations

It is tested and working on Centos 7.2/7.3 with Puppet 4.8.1. Not working with Puppet 3!


# Development

The future task which needs to be done is testing any new versions of SLURM and checking if the current module still supports the latest features.

As always, changes should be done in a new branch first for testing and then a merged to qa using a merge request. Once the module is validated in qa for at least one week, the changes can be merged into master.

Please document all changes in the CHANGELOG and update this README if necessary!

# Contributors

  * Philippe Ganz (CERN) as creator and main maintainer
  * Carolina Lindqvist (CERN) as creator and main maintainer
