# == Class: slurm::master::config
#
class slurm::master::config {

  include slurm

  File {
    owner => $slurm::slurm_user,
    group => $slurm::slurm_user_group,
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

  file { 'StateSaveLocation':
    ensure  => 'directory',
    path    => $slurm::state_save_location,
    mode    => '0700',
    require => File[$slurm::shared_state_dir],
  }

  file { 'JobCheckpointDir':
    ensure  => 'directory',
    path    => $slurm::job_checkpoint_dir,
    mode    => '0700',
    require => File[$slurm::shared_state_dir],
  }

  if $slurm::manage_state_dir_nfs_mount {
    mount { 'StateSaveLocation':
      ensure  => 'mounted',
      name    => $slurm::state_save_location,
      atboot  => true,
      device  => $slurm::state_dir_nfs_device,
      fstype  => 'nfs',
      options => $slurm::state_dir_nfs_options,
      require => File['StateSaveLocation'],
    }
  }

  if $slurm::slurm_conf_source {
    file { '/etc/slurm/slurm.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => $slurm::slurm_conf_source,
      notify  => Service['slurm'],
    }
  } else {
    concat_build { 'slurm.conf': }

    file { '/etc/slurm/slurm.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => concat_output('slurm.conf'),
      require => Concat_build['slurm.conf'],
      #notify  => Service['slurm'],
    }

    concat_fragment { 'slurm.conf+01-common':
      content => template('slurm/slurm.conf/common/slurm.conf.options.erb'),
    }

    concat_fragment { 'slurm.conf+03-partitions':
      content => $slurm::partition_content,
    }

    Concat_fragment <<| tag == 'slurm_nodelist' |>>
  }

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
      create_owner  => $slurm::slurm_user,
      create_group  => 'root',
      postrotate    => '/etc/init.d/slurm reconfig >/dev/null 2>&1',
    }
  }

  sysctl { 'net.core.somaxconn':
    ensure  => present,
    value   => '1024',
  }

}
