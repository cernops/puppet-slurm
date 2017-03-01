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

This module installs the SLURM scheduler needed to run parallel programs on a distributed HPC cluster.

It setups, configures and installs all the required binaries and configuration files according to the parameters detailed [below](#beginning-with-slurm). It relies on hiera data provided by the hostgroup it is installed on.

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
 - 'slurm-sjobexit',
 - 'slurm-sjstat',
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
 - 'slurm-sjobexit',
 - 'slurm-sjstat',
 - 'slurm-torque',
```


### Dependencies

#### Authentication
TODO Bla bla Munge...

#### Checkpointing
TODO Bla bla BLCR...

#### Data base
TODO Bla bla MySQL, MariaDB...

#### More Bla bla
TODO Bla bla


## Setup Requirements

The module needs to be enabled in the pluginsync filter since it's not a standard CERN module :
```
# my_hostgroup.yaml

...

# enabling the slurm module
pluginsync_filter:
 - slurm

...
```

### Hiera data details here...

## Beginning with slurm

To use the module, simply include it in your hostgroup manifest :
```
# my_hostgroup.pp

...

# including slurm to be able to do some awesome scheduling on HPC machines
  include 'slurm'

...
```

### ...or Hiera data details here.

# Usage

Please refer to the official [SLURM documentation](https://slurm.schedmd.com/).

TODO Specific usage at CERN ? Probably yes...


# Reference

## slurm
```
class slurm ()
```
TODO Bla bla

## slurm::setup
```
class slurm::setup (
  String $slurm_home     = '/usr/local/slurm',
  String $slurm_log      = '/var/log/slurm',
  Integer $slurm_gid     = 950,
  Integer $slurm_uid     = 950,
  String $slurm_key_priv = 'slurmkey',
  String $slurm_key_pub  = 'slurmcert',
  Integer $munge_gid     = 951,
  Integer $munge_uid     = 951,
  String $munge_folder   = '/etc/munge',
  String $munge_log      = '/var/log/munge',
  String $munge_home     = '/var/lib/munge',
  String $munge_run      = '/run/munge',
  String $munge_key      = 'mungekey',
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
  String $headnode           = 'headnode1.example.org',
  String $failover           = 'headnode2.example.org',
  String $checkpoint_dir     = '/var/slurm/checkpoint',
  String $slurmkey_loc       = '/usr/local/slurm/credentials/slurm.key',
  String $slurmcert_loc      = '/usr/local/slurm/credentials/slurm.cert',
  Integer $maxjobcount       = 5000,
  String $plugin_dir         = '/usr/lib64/slurm',
  String $plugstackconf_file = '/etc/slurm/plugstack.conf',
  Integer $slurmctld_port    = 6817,
  Integer $slurmd_port       = 6818,
  String $slurmdspool_dir    = '/var/spool/slurmd',
  String $slurmstate_dir     = '/var/spool/slurmctld/slurm.state',
  String $slurmuser          = 'slurm',
  String $slurmdbd_host      = 'accountingdb.example.org',
  String $slurmdbd_loc       = 'accountingdb',
  Integer $slurmdbd_port     = 6819,
  String $slurmdbd_user      = 'slurm',
  String $clustername        = 'batch',
  String $jobcomp_db_host    = 'jobcompdb.example.org',
  String $jobcomp_db_loc     = 'jobcompdb',
  Integer $jobcomp_db_port   = 6819,
  String $jobcomp_db_user    = 'slurm',
  String $slurmctld_log      = '/var/log/slurm/slurmctld.log',
  String $slurmd_log         = '/var/log/slurm/slurmd.log',
  Array $workernodes         = [{'NodeName' => 'worker[00-10]', 'CPUs' => '16'}],
  Array $partitions          = [{'PartitionName' => 'workers', 'MaxMemPerCPU' => '2000'}],
)
```
TODO I do not want to do this one! :''(

## slurm::dbnode
```
class slurm::dbnode ()
```
Setup, configure and installs the dbnode type.


### slurm::dbnode::setup
```
class slurm::dbnode::setup (
  String $jobacct_log = '/var/log/slurm/slurm_jobacct.log',
  String $jobcomp_log = '/var/log/slurm/slurm_jobcomp.log',
  String $slurmdbd_log = '/var/log/slurm/slurmdbd.log',
  Array $packages = [
    'slurm-plugins',
    'slurm-slurmdbd',
    'slurm-sql',
  ],
)
```
Setup the dbnode type.


### slurm::dbnode::config
```
class slurm::dbnode::config (
  String $slurmdb_host   = 'dbnode.example.org',
  Integer $slurmdb_port  = 6819,
  String $slurmuser      = 'slurm',
  String $db_host        = 'db_service.example.org',
  Integer $db_port       = 1234,
  String $db_user        = 'user',
  String $db_loc         = 'accountingdb',
)
```
Configure the dbnode type.

### slurm::dbnode::firewall
```
class slurm::dbnode::firewall (
  Integer $slurmdbd_port = 6819,
)
```
Setup the firewall for the dbnode type.


## slurm::headnode
```
class slurm::headnode ()
```
Setup, configure and installs the headnode type.


### slurm::headnode::setup
```
class slurm::headnode::setup (
  String $slurmctld_folder   = '/var/spool/slurmctld',
  String $slurm_state_folder = '/var/spool/slurmctld/slurm.state',
  String $slurmctld_log      = '/var/log/slurm/slurmctld.log',
  Array $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-sjobexit',
    'slurm-sjstat',
    'slurm-torque',
  ],
)
```
Setup the headnode type.


### slurm::headnode::config
```
class slurm::headnode::config ()
```
Configure the headnode type.

### slurm::headnode::firewall
```
class slurm::headnode::firewall (
  Integer $slurmctld_port = 6817,
)
```
Setup the firewall for the headnode type.


## slurm::workernode
```
class slurm::workernode ()
```
Setup, configure and installs the workernode type.


### slurm::workernode::setup
```
class slurm::workernode::setup (
  String $slurmd_folder = '/var/spool/slurmd',
  String $slurmd_log    = '/var/log/slurm/slurmd.log',
  Array $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-sjobexit',
    'slurm-sjstat',
    'slurm-torque',
  ],
)
```
Setup the workernode type.


### slurm::slurmworkernode::config
```
class slurm::slurmworkernode::config ()
```
Configure the workernode type.

### slurm::slurmworkernode::firewall
```
class slurm::workernode::firewall (
  Integer $slurmd_port = 6818,
)
```
Setup the firewall for the workernode type.

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

### slurmdb.conf.erb
TODO Bla bla


# Limitations

It is tested and working on Centos 7.2/7.3 with Puppet 4.8.1. Not working with Puppet 3!


# Development

The future tasks needed will be to test the new versions of SLURM and check if the current module still supports the latest features.

As always, changes should be done in a new branch first for testing and then a merge request made to qa. Once the module is validated in qa for at least one week, it can be merged into master.

Please document all your doing in the CHANGELOG and update this README if need be!

# Contributors

  * Philippe Ganz (CERN) as creator and main maintainer
  * Carolina Lindqvist (CERN) as creator and main maintainer
