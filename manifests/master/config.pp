# == Class: slurm::master::config
#
class slurm::master::config {

  include slurm

  if $slurm::manage_slurm_group {
    $gid = $slurm::slurm_group_gid ? {
      'UNSET' => undef,
      default => $slurm::slurm_group_gid,
    }

    group { 'slurm':
      ensure  => present,
      name    => $slurm::slurm_user_group,
      gid     => $gid,
    }
  }

  if $slurm::manage_slurm_user {
    $uid = $slurm::slurm_user_uid ? {
      'UNSET' => undef,
      default => $slurm::slurm_user_uid,
    }

    user { 'slurm':
      ensure  => present,
      name    => $slurm::slurm_user,
      uid     => $uid,
      gid     => $slurm::slurm_user_group,
      shell   => $slurm::slurm_user_shell,
      home    => $slurm::slurm_user_home,
      comment => $slurm::slurm_user_comment,
    }
  }

  File {
    owner => 'slurm',
    group => 'slurm',
  }

  file { $slurm::log_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $slurm::pid_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $slurm::shared_state_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $slurm::spool_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $slurm::state_save_location:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $slurm::job_checkpoint_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  if $slurm::manage_state_dir_nfs_mount {
    mount { $slurm::state_save_location:
      ensure  => 'mounted',
      atboot  => true,
      device  => $slurm::state_dir_nfs_device,
      fstype  => 'nfs',
      options => $slurm::state_dir_nfs_options,
      require => File[$slurm::state_save_location],
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
    content => $slurm::partition_content,
    source  => $slurm::partition_source,
    order   => 3,
  }

  Concat::Fragment <<| tag == 'slurm_nodelist' |>>

  if $slurm::manage_logrotate {
    #Refer to: https://computing.llnl.gov/linux/slurm/slurm.conf.html#lbAJ
    logrotate::rule { 'slurmctld':
      path          => $slurm::slurmctld_log_file,
      compress      => true,
      missingok     => true,
      copytruncate  => false,
      delaycompress => false,
      ifempty       => false,
      rotate        => 10,
      sharedscripts => true,
      size          => '10M',
      create        => true,
      create_mode   => '0640',
      create_owner  => 'slurm',
      create_group  => 'root',
      postrotate    => '/etc/init.d/slurm reconfig >/dev/null 2>&1',
    }
  }

  sysctl { 'net.core.somaxconn':
    ensure  => present,
    value   => '1024',
  }

}
