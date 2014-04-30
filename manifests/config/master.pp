# == Class: slurm::config::master
#
class slurm::config::master {

  include slurm::config

  File {
    owner => 'slurm',
    group => 'slurm',
  }

  file { $slurm::state_save_location:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $slurm::job_checkpoint_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  if $slurm::state_dir_nfs_mount {
    mount { $slurm::state_save_location:
      ensure  => 'mounted',
      atboot  => true,
      device  => $slurm::state_dir_nfs_device,
      fstype  => 'nfs',
      options => $slurm::state_dir_nfs_options,
      require => File[$slurm::state_save_location],
    }
  }

  if $slurm::manage_logrotate {
    #Refer to: https://computing.llnl.gov/linux/slurm/slurm.conf.html#lbAJ
    logrotate::rule { 'slurmctld':
      path          => $slurm::config::slurmctld_log_file,
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

/*
  file { '/etc/slurm/plugstack.conf.d':
    ensure  => 'directory',
    require => Class['slurm::master::install'],
    notify  => Class['slurm::master::service']
  }

  file{'/etc/slurm/plugstack.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/plugstack.conf.erb'),
    require => Class['slurm::master::install'],
    notify  => Class['slurm::master::service']
  }

  file{'/etc/slurm/plugstack.conf.d/auks.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/plugstack.conf.d/auks.conf.erb'),
    require => Class['slurm::master::install'],
    notify  => Class['slurm::master::service']
  }
*/
}
