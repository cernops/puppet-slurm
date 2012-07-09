class slurm::slurmdb::config {

  if ( $::osfamily != 'RedHat' ) {
    fail('This module is only tested on RedHat based machines')
  }

  # Not sure if this is necessary.
  concat{'/etc/slurm/slurm.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['slurm::slurmdb::install'],
    notify  => Class['slurm::slurmdb::service']
  }

  concat::fragment{'slurmdb-options':
    target  => '/etc/slurm/slurm.conf',
    content => template('slurm/slurm.conf/common/slurm.conf.options.erb'),
    order   => 1
  }

  file{'/etc/slurm/slurmdbd.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/slurmdbd.conf.erb'),
    require => Class['slurm::slurmdb::install'],
    notify  => Class['slurm::slurmdb::service']
  }

  logrotate::file { "slurmdbd.log":
    log => "/var/log/slurm/slurmdbd.log",
    options => ['compress', 'rotate 10', 'size 10M', 'nomail'],
    postrotate => "/sbin/service slurmdbd reconfig >/dev/null 2>&1",
  }
}
