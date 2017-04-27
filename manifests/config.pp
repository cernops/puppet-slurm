# slurm/config.pp
#
# Creates the common configuration files
#
# @param control_machine The short, or long, hostname of the machine where Slurm control functions are executed.
# @param backup_controller The short, or long, name of the machine where Slurm control functions are to be executed in the event that control_machine fails.
# @param auth_type The authentication method for communications between Slurm components.
# @param checkpoint_type The system-initiated checkpoint method to be used for user jobs.
# @param crypto_type The cryptographic signature tool to be used in the creation of job step credentials.
# @param job_checkpoint_dir Specifies the default directory for storing or reading job checkpoint information.
# @param job_credential_private_key Fully qualified pathname of a file containing a private key used for authentication by Slurm daemons.
# @param job_credential_public_certificate Fully qualified pathname of a file containing a public key used for authentication by Slurm daemons.
# @max_tasks_per_node Maximum number of tasks Slurm will allow a job step to spawn on a single node.
# @param mpi_default Identifies the default type of MPI to be used.
# @param max_job_count The maximum number of jobs Slurm can have in its active database at one time.
# @param plugin_dir Identifies the places in which to look for Slurm plugins.
# @param plug_stack_config Location of the config file for Slurm stackable plugins that use the Stackable Plugin Architecture for Node job (K)control (SPANK).
# @param private_data This controls what type of information is hidden from regular users.
# @param proctrack_type Identifies the plugin to be used for process tracking on a job step basis.
# @param slurmctld_port The port number that the Slurm controller, slurmctld, listens to for work.
# @param slurmd_port The port number that the Slurm compute node daemon, slurmd, listens to for work.
# @param slurmd_spool_dir Fully qualified pathname of a directory into which the slurmd daemon's state information and batch job script information are written.
# @param state_save_location Fully qualified pathname of a directory into which the Slurm controller, slurmctld, saves its state.
# @param $task_plugin Identifies the type of task launch plugin, typically used to provide resource management within a node (e.g. pinning tasks to specific processors).
# @param $task_plugin_param Optional parameters for the task plugin.
# @param $topology_plugin Identifies the plugin to be used for determining the network topology and optimizing job allocations to minimize network contention.
# @param $tree_width Slurmd daemons use a virtual tree network for communications. TreeWidth specifies the width of the tree (i.e. the fanout). Optimal system performance can typically be achieved if TreeWidth is set to the square root of the number of nodes in the cluster for systems having no more than 2500 nodes or the cube root for larger systems.
# @param $unkillable_step_program If the processes in a job step are determined to be unkillable for a period of time specified by the UnkillableStepTimeout variable, the program specified by UnkillableStepProgram will be executed.
# @param $def_mem_per_cpu Default real memory size available per allocated CPU in megabytes.
# @param $scheduler_type Identifies the type of scheduler to be used.
# @param $select_type Identifies the type of resource selection algorithm to be used.
# @param $select_type_parameters The permitted values of SelectTypeParameters depend upon the configured value of SelectType.
# @param priority_type This specifies the plugin to be used in establishing a job's scheduling priority.
# @param priority_flags Flags to modify priority behavior.
# @param priority_calc_period The period of time in minutes in which the half-life decay will be re-calculated.
# @param priority_decay_half_life This controls how long prior resource use is considered in determining how over- or under-serviced an association is (user, bank account and cluster) in determining job priority.
# @param priority_favor_small Specifies that small jobs should be given preferential scheduling priority.
# @param priority_max_age Specifies the job age which will be given the maximum age factor in computing priority.
# @param priority_usage_reset_period At this interval the usage of associations will be reset to 0.
# @param priority_weight_age An integer value that sets the degree to which the queue wait time component contributes to the job's priority.
# @param priority_weight_fairshare An integer value that sets the degree to which the fair-share component contributes to the job's priority.
# @param priority_weight_job_size An integer value that sets the degree to which the job size component contributes to the job's priority.
# @param priority_weight_partition Partition factor used by priority/multifactor plugin in calculating job priority.
# @param priority_weight_qos An integer value that sets the degree to which the Quality Of Service component contributes to the job's priority.
# @param priority_weight_tres A comma separated list of TRES Types and weights that sets the degree that each TRES Type contributes to the job's priority.
# @param slurm_user The name of the user that the slurmctld daemon executes as.
# @param accounting_storage_host The name of the machine hosting the accounting storage database.
# @param accounting_storage_loc The fully qualified file name where accounting records are written when the AccountingStorageType is "accounting_storage/filetxt" or else the name of the database where accounting records are stored when the AccountingStorageType is a database.
# @param accounting_storage_port The listening port of the accounting storage database server.
# @param $accounting_storage_type The accounting storage mechanism type.
# @param accounting_storage_user The user account for accessing the accounting storage database.
# @param cluster_name The name by which this Slurm managed cluster is known in the accounting database.
# @param $job_acct_gather_frequency The job accounting and profiling sampling intervals.
# @param $acct_gather_energy_type Identifies the plugin to be used for energy consumption accounting.
# @param $acct_gather_infiniband_type Identifies the plugin to be used for infiniband network traffic accounting.
# @param $acct_gather_filesystem_type Identifies the plugin to be used for filesystem traffic accounting.
# @param $acct_gather_profile_type Identifies the plugin to be used for detailed job profiling.
# @param $slurmctld_debug The level of detail to provide slurmctld daemon's logs.
# @param slurmctld_log_file Fully qualified pathname of a file into which the slurmctld daemon's logs are written.
# @param $slurmd_debug The level of detail to provide slurmd daemon's logs.
# @param slurmd_log_file Fully qualified pathname of a file into which the slurmd daemon's logs are written.
# @param workernodes Array of hashes containing the information about the workernodes.
# @param partitions Array of hashes containing the information about the paritions.
#
# version 20170427
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

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
  String $select_type                       = 'select/linear',
  String $select_type_parameters            = 'CR_Memory',
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
) {

  # Common SLURM configuration file
  file{'/etc/slurm/slurm.conf':
    ensure  => file,
    content => template('slurm/slurm.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }

  # AcctGatherEnergy/impi plugin
  file{'/etc/slurm/acct_gather.conf':
    ensure  => file,
    content => template('slurm/acct_gather.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }

  # Cgroup configuration
  file{ '/etc/slurm/cgroup.conf':
    ensure  => file,
    content => template('slurm/cgroup.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }

  # Plugin loader
  file{ '/etc/slurm/plugstack.conf':
    ensure  => file,
    content => template('slurm/plugstack.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }

  # Topology file
  file{'/etc/slurm/topology.conf':
    ensure  => file,
    content => template('slurm/topology.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }

  # Authentication service for SLURM
  service{'munge':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => File['munge homedir','/etc/munge/munge.key'],
  }
}
