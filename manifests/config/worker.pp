# == Class: slurm::config::worker
#
class slurm::config::worker {

  include slurm::config

  $slurmd_spool_dir = $slurm::config::slurmd_spool_dir
  $epilog           = $slurm::config::epilog
  $prolog           = $slurm::config::prolog
  $task_prolog      = $slurm::config::task_prolog

  $tmp_disk         = $slurm::tmp_disk

  $procs = $::physicalprocessorcount*$::corecountpercpu*$::threadcountpercore

  File {
    owner => 'slurm',
    group => 'slurm',
  }

  file { $slurmd_spool_dir:
    ensure  => 'directory',
    mode    => '0755',
  }

  if $epilog {
    file { 'epilog':
      ensure  => 'file',
      path    => $epilog,
      source  => $slurm::epilog_source,
      owner   => 'root',
      group   => 'root',
      mode    => '0754',
    }
  }

  if $prolog {
    file { 'prolog':
      ensure  => 'file',
      path    => $prolog,
      source  => $slurm::prolog_source,
      owner   => 'root',
      group   => 'root',
      mode    => '0754',
    }
  }

  if $task_prolog {
    file { 'task_prolog':
      ensure  => 'file',
      path    => $task_prolog,
      source  => $slurm::task_prolog_source,
      owner   => 'root',
      group   => 'root',
      mode    => '0754',
    }
  }

  @@concat::fragment { "slurm.conf-nodelist_${::hostname}":
    tag     => 'slurm_nodelist',
    target  => '/etc/slurm/slurm.conf',
    content => template('slurm/slurm.conf/worker/slurm.conf.nodelist.erb'),
    order   => 2,
  }

  if $slurm::manage_logrotate {
    #Refer to: https://computing.llnl.gov/linux/slurm/slurm.conf.html#lbAJ
    logrotate::rule { 'slurmd':
      path          => $slurm::config::slurmd_log_file,
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
  file{'/etc/slurm/plugstack.conf.d':
    ensure  => 'directory',
    require => Class['slurm::worker::install'],
    notify  => Class['slurm::worker::service']
  }

  file{'/etc/slurm/plugstack.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/plugstack.conf.erb'),
    require => Class['slurm::worker::install'],
    notify  => Class['slurm::worker::service']
  }

  file{'/etc/slurm/plugstack.conf.d/auks.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/plugstack.conf.d/auks.conf.erb'),
    require => Class['slurm::worker::install'],
    notify  => Class['slurm::worker::service']
  }

  file{'/etc/sysconfig/slurm':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "export KRB5CCNAME=${auks::params::aukspriv_cc_filepath}\n",
    require => Class['slurm::worker::install'],
    notify  => Class['slurm::worker::service']
  }
*/
}
