# slurm/config.pp
#
# Creates the common configuration file
#
# version 20170301
#
# @param headnode
# @param failover
# @param checkpoint_dir
# @param slurmkey_loc
# @param slurmcert_loc
# @param maxjobcount
# @param plugin_dir
# @param plugstackconf_file
# @param slurmctld_port
# @param slurmd_port
# @param slurmdspool_dir
# @param slurmstate_dir
# @param slurmuser
# @param slurmdbd_host
# @param slurmdbd_loc
# @param slurmdbd_port
# @param slurmdbd_user
# @param clustername
# @param jobcomp_db_host
# @param jobcomp_db_loc
# @param jobcomp_db_port
# @param jobcomp_db_user
# @param slurmctld_log
# @param slurmd_log
# @param workernodes
# @param partitions
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

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
) {

  teigi::secret::sub_file{'/etc/slurm/slurm.conf':
    teigi_keys => ['slurmdbpass'],
    content    => template('slurm/slurm.conf.erb'),
    owner      => 'slurm',
    group      => 'slurm',
    mode       => '0644',
  }

  file{'/etc/slurm/acct_gather.conf':
    ensure  => file,
    content => template('slurm/acct_gather.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
  }

  service{'munge':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => File['munge homedir','/etc/munge/munge.key'],
  }
}
