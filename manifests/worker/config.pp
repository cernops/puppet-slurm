class slurm::worker::config {

  if ( $::osfamily != 'RedHat' ) {
    fail('This module is only tested on RedHat based machines')
  }

  file{'/var/spool/slurmd':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  concat{'/etc/slurm/slurm.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['slurm::worker::install'],
    notify  => Class['slurm::worker::service']
  }

  $fakecpucount = $::physicalprocessorcount*$::corecountpercpu*
    $::threadcountpercore*$slurm::params::slurm_worker_slot_multiplier

  concat::fragment{'worker-options':
    target  => '/etc/slurm/slurm.conf',
    content => template('slurm/slurm.conf/common/slurm.conf.options.erb'),
    order   => 1
  }

  concat::fragment{'worker-nodelist':
    target  => '/etc/slurm/slurm.conf',
    content => template('slurm/slurm.conf/worker/slurm.conf.nodelist.erb'),
    order   => 2
  }

  @@concat::fragment{"slurm_nodelist_${::hostname}":
    tag     => "${::hostgroup_0}_slurm_nodelist",
    order   => "2",
    target  => "/etc/slurm/slurm.conf",
    content => template('slurm/slurm.conf/worker/slurm.conf.nodelist.erb'),
  }

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

  logrotate::file { "slurmd.log":
    log => "/var/log/slurm/slurmd.log",
    options => ['compress', 'rotate 10', 'size 10M', 'nomail'],
    postrotate => "/sbin/service slurm reconfig >/dev/null 2>&1",
  }
}
