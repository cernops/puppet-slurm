class slurm::master::config {

  if ( $::osfamily != 'RedHat' ) {
    fail('This module is only tested on RedHat based machines')
  }

  file{'/var/spool/slurmctld':
    ensure  => 'directory',
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0750',
  }

  file{'/var/spool/slurmctld/state':
    ensure  => 'directory',
  }

  $nfs_volume = hiera('slurm_sharedstate_nfs_url', undef)

  if $nfs_volume {
      augeas{'cluster state':
        context => "/files/etc/fstab/",
        changes => [
          "set 01/spec ${nfs_volume}",
          "set 01/file /var/spool/slurmctld/state",
          "set 01/vfstype nfs",
          "set 01/opt[1] sync",
          "set 01/opt[2] rw",
          "set 01/opt[3] noexec",
          "set 01/opt[4] nolock",
          "set 01/opt[5] auto",
          "set 01/dump 0",
          "set 01/passno 0",
        ],
        onlyif => "match *[spec='${nfs_volume}'] size == 0",
      }
  }

  exec{'mount-auto-filesystems':
    cwd         => "/",
    path        => "/bin",
    command     => "mount -a",
    require     => File['/var/spool/slurmctld/state'],
    onlyif      => "/bin/grep -q ${nfs_volume} /proc/mounts ; /usr/bin/test $? -eq 1"
    #refreshonly => true
  }

  concat{'/etc/slurm/slurm.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['slurm::master::install'],
    #notify  => Class['slurm::master::service']
  }

  concat::fragment{'master-options':
    target  => '/etc/slurm/slurm.conf',
    content => template('slurm/slurm.conf/common/slurm.conf.options.erb'),
    order   => 1
  }

  Concat::Fragment <<| tag == "${::hostgroup_0}_slurm_nodelist" |>>

  concat::fragment{'master-partitions':
    target  => '/etc/slurm/slurm.conf',
    content => template('slurm/slurm.conf/master/slurm.conf.partitions.erb'),
    order   => 3
  }

  file{'/etc/slurm/plugstack.conf.d':
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

  logrotate::file { "slurmctld.log":
    log => "/var/log/slurm/slurmctld.log",
    options => ['compress', 'rotate 10', 'size 10M', 'nomail'],
    postrotate => "/sbin/service slurm reconfig >/dev/null 2>&1",
  }
}
