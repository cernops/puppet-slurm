# slurm/config.pp
#
# Creates the common configuration file
#
# @param control_machine The short, or long, hostname of the machine where Slurm control functions are executed
# @param backup_controller The short, or long, name of the machine where Slurm control functions are to be executed in the event that control_machine fails
# @param job_checkpoint_dir Specifies the default directory for storing or reading job checkpoint information
# @param job_credential_private_key Fully qualified pathname of a file containing a private key used for authentication by Slurm daemons
# @param job_credential_public_certificate Fully qualified pathname of a file containing a public key used for authentication by Slurm daemons
# @param max_job_count The maximum number of jobs Slurm can have in its active database at one time
# @param plugin_dir Identifies the places in which to look for Slurm plugins
# @param plug_stack_config Location of the config file for Slurm stackable plugins that use the Stackable Plugin Architecture for Node job (K)control (SPANK)
# @param slurmctld_port The port number that the Slurm controller, slurmctld, listens to for work
# @param slurmd_port The port number that the Slurm compute node daemon, slurmd, listens to for work
# @param slurmd_spool_dir Fully qualified pathname of a directory into which the slurmd daemon's state information and batch job script information are written
# @param state_save_location Fully qualified pathname of a directory into which the Slurm controller, slurmctld, saves its state
# @param slurm_user The name of the user that the slurmctld daemon executes as
# @param accounting_storage_host The name of the machine hosting the accounting storage database
# @param accounting_storage_loc The fully qualified file name where accounting records are written when the AccountingStorageType is "accounting_storage/filetxt" or else the name of the database where accounting records are stored when the AccountingStorageType is a database
# @param accounting_storage_port The listening port of the accounting storage database server
# @param accounting_storage_user The user account for accessing the accounting storage database
# @param cluster_name The name by which this Slurm managed cluster is known in the accounting database
# @param slurmctld_log_file Fully qualified pathname of a file into which the slurmctld daemon's logs are written
# @param slurmd_log_file Fully qualified pathname of a file into which the slurmd daemon's logs are written
# @param amount_of_nodes The total amount of nodes contained in the cluster
# @param workernodes Array of hashes containing the information about the workernodes
# @param partitions Array of hashes containing the information about the paritions
#
# version 20170331
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
  Integer $amount_of_nodes                  = 1,
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
) {

  teigi::secret::sub_file{'/etc/slurm/slurm.conf':
    teigi_keys => ['slurmdbpass'],
    content    => template('slurm/slurm.conf.erb'),
    owner      => 'slurm',
    group      => 'slurm',
    mode       => '0644',
  }

  file{'/etc/slurm/topology.conf':
    ensure  => file,
    content => template('slurm/topology.conf.erb'),
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
