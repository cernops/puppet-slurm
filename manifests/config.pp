# slurm/config.pp
#
# Creates the common configuration file
#
# @param control_machine
# @param backup_controller
# @param job_checkpoint_dir
# @param job_credential_private_key
# @param job_credential_public_certificate
# @param max_job_count
# @param plugin_dir
# @param plug_stack_config
# @param slurmctld_port
# @param slurmd_port
# @param slurmd_spool_dir
# @param state_save_location
# @param slurm_user
# @param accounting_storage_host
# @param accounting_storage_loc
# @param accounting_storage_port
# @param accounting_storage_user
# @param cluster_name
# @param slurmctld_log_file
# @param slurmd_log_file
# @param workernodes
# @param partitions
#
# version 20170306
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

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
