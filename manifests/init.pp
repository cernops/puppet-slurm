# Being of class 'slurm' means that the machine is prepared
# for being either a master or a worker node. For the moment,
# the only way to configure a machine to act as any of them is
# by adding it to slurm::master or slurm::worker manually.
class slurm (
  # Role booleans
  $worker = true,
  $master = false,
  $slurmdb = false,

  # Package ensures
  $munge_package_ensure = 'present',
  $slurm_package_ensure = 'present',
  $auks_package_ensure = 'present',
  $package_runtime_dependencies = $slurm::params::package_runtime_dependencies,

  # User/group management
  $manage_group = true,
  $group_gid = 'UNSET',
  $manage_user = true,
  $user_uid = 'UNSET',
  $user_comment = 'SLURM User',
  $user_home = '/home/slurm',
  $user_shell = '/bin/false',

  # Master config
  $state_dir_nfs_mount = true,
  $state_dir_nfs_device = undef,
  $state_dir_nfs_options = 'rw,sync,noexec,nolock,auto',

  # Worker config
  $tmp_disk = '16000',

  # Partitions
  $partitionlist = [],
  $partitionlist_content = undef,
  $partitionlist_source = undef,

  # Managed directories
  $log_dir = '/var/log/slurm',
  $pid_dir = '/var/run/slurm',
  $spool_dir = '/var/spool/slurm',
  $shared_state_dir = '/var/lib/slurm',

  # slurm.conf - common
  $accounting_storage_host = $::fqdn,
  $accounting_storage_pass = 'slurmdb',
  $accounting_storage_user = 'slurmdb',
  $cluster_name = 'linux',
  $control_machine = $::hostname,
  $epilog = 'UNSET',
  $epilog_source = undef,
  $job_checkpoint_dir = '/var/lib/slurm/checkpoint',
  $max_job_count = 5000,
  $mpi_params = 'UNSET',
  $preempt_mode = 'SUSPEND,GANG',
  $preempt_type = 'preempt/partition_prio',
  $priority_decay_half_life = '7-0',
  $priority_type = 'priority/basic',
  $priority_usage_reset_period = 'NONE',
  $proctrack_type = 'proctrack/linuxproc',
  $prolog = 'UNSET',
  $prolog_source = undef,
  $propagate_resource_limits = 'NONE',
  $return_to_service = '0',
  $select_type = 'select/linear',
  $select_type_parameters = 'CR_Memory',
  $state_save_location = '/var/lib/slurm/state',
  $task_plugin = 'task/none',
  $task_plugin_param = 'None',
  $task_prolog = 'UNSET',
  $task_prolog_source = undef,

  # slurmdbd.conf
  $storage_type = 'accounting_storage/mysql',
  $storage_host = 'localhost',
  $storage_port = '3306',
  $storage_loc = 'slurmdb',
  $storage_user = 'slurmdb',
  $storage_pass = 'slurmdb',

  # Munge
  $munge_key = 'UNSET',

  # auks
  $use_auks = false,

  # Firewall / ports
  $manage_firewall = true,
  $slurmd_port = '6818',
  $slurmctld_port = '6817',
  $slurmdbd_port = '6819',

  # Logrotate
  $manage_logrotate = true,
) inherits slurm::params {

  $slurmd_spool_dir = inline_template('<%= File.join(scope.lookupvar("slurm::spool_dir"), "slurmd") %>')

  $_epilog = $epilog ? {
    'UNSET' => undef,
    default => $epilog,
  }

  $_prolog = $prolog ? {
    'UNSET' => undef,
    default => $prolog,
  }

  $_task_prolog = $task_prolog ? {
    'UNSET' => undef,
    default => $task_prolog,
  }

  anchor { 'slurm::start': }->
  class { 'slurm::install': }->
  class { 'slurm::config': }->
  class { 'slurm::firewall': }->
  class { 'slurm::service': }->
  anchor { 'slurm::end': }

  if $worker or $master {
    class { 'slurm::munge': }->
    Class['slurm::install']
  }

  if $worker {
    Class['slurm::config']->
    class { 'slurm::config::worker': }
  }

  if $master {
    Class['slurm::config']->
    class { 'slurm::config::master': }
  }

  if $slurmdb {
    Class['slurm::config']->
    class { 'slurm::config::slurmdb': }
  }

}
