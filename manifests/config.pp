# == Class: slurm::config
#
class slurm::config {

  include slurm

  $log_dir                = $slurm::log_dir
  $slurmctld_log_file     = inline_template('<%= File.join(@log_dir, "slurmctld.log") %>')
  $slurmd_log_file        = inline_template('<%= File.join(@log_dir, "slurmd.log") %>')
  $pid_dir                = $slurm::pid_dir
  $shared_state_dir       = $slurm::shared_state_dir
  $spool_dir              = $slurm::spool_dir
  $slurmd_spool_dir       = $slurm::slurmd_spool_dir
  $epilog                 = $slurm::_epilog
  $prolog                 = $slurm::_prolog
  $task_prolog            = $slurm::_task_prolog
  $partitionlist_content  = $slurm::partitionlist_content
  $partitionlist_source   = $slurm::partitionlist_source

  if $partitionlist_content {
    $partition_source   = undef
    $partition_content  = template($partitionlist_content)
  } elsif $partitionlist_source {
    $partition_source   = $partitionlist_source
    $partition_content  = undef
  } else {
    $partition_source   = undef
    $partition_content  = template('slurm/slurm.conf/master/slurm.conf.partitions.erb')
  }

  File {
    owner => 'slurm',
    group => 'slurm',
  }

  file { $log_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $pid_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $shared_state_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $spool_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  if $slurm::manage_group {
    $_group_gid = $slurm::group_gid ? {
      'UNSET' => undef,
      default => $slurm::group_gid,
    }

    group { 'slurm':
      ensure  => present,
      gid     => $_group_gid,
    }
  }

  if $slurm::manage_user {
    $_user_uid = $slurm::user_uid ? {
      'UNSET' => undef,
      default => $slurm::user_uid,
    }

    user { 'slurm':
      ensure  => present,
      uid     => $_user_uid,
      gid     => 'slurm',
      shell   => $slurm::user_shell,
      home    => $slurm::user_home,
      comment => $slurm::user_comment,
    }
  }

  concat { '/etc/slurm/slurm.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    #notify  => Class['slurm::master::service']
  }

  concat::fragment { 'slurm.conf-common':
    target  => '/etc/slurm/slurm.conf',
    content => template('slurm/slurm.conf/common/slurm.conf.options.erb'),
    order   => 1,
  }

  concat::fragment { 'slurm.conf-partitions':
    target  => '/etc/slurm/slurm.conf',
    content => $partition_content,
    source  => $partition_source,
    order   => 3,
  }

  Concat::Fragment <<| tag == 'slurm_nodelist' |>>

  sysctl { 'net.core.somaxconn':
    ensure  => present,
    value   => '1024',
  }

}
