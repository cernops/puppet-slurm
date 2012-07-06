class slurm::slurmdb::config {

  if ( $::osfamily != 'RedHat' ) {
    fail('This module is only tested on RedHat based machines')
  }

  # Not sure if this is necessary.
  file{'/etc/slurm/slurm.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/slurm.conf.erb'),
    require => Class['slurm::slurmdb::install'],
    notify  => Class['slurm::slurmdb::service']
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
