# == Class: slurm::config
#
class slurm::config (
  $manage_slurm_conf = true,
) {

  include slurm

  $partitionlist    = $slurm::partitionlist
  $slurm_conf       = $slurm::slurm_conf
  $conf_dir         = $slurm::conf_dir
  $slurm_conf_path  = $slurm::slurm_conf_path

  File {
    owner => $slurm::slurm_user,
    group => $slurm::slurm_user_group,
  }

  file { 'slurm CONFDIR':
    ensure  => 'directory',
    path    => $conf_dir,
    mode    => '0755',
  }

  file { '/etc/sysconfig/slurm':
    ensure  => 'file',
    path    => '/etc/sysconfig/slurm',
    content => template('slurm/sysconfig/slurm.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/profile.d/slurm.sh':
    ensure  => 'file',
    path    => '/etc/profile.d/slurm.sh',
    content => template('slurm/profile.d/slurm.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/profile.d/slurm.csh':
    ensure  => 'file',
    path    => '/etc/profile.d/slurm.csh',
    content => template('slurm/profile.d/slurm.csh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $manage_slurm_conf {
    if $slurm::slurm_conf_source {
      file { 'slurm.conf':
        ensure  => 'file',
        path    => $slurm_conf_path,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => $slurm::slurm_conf_source,
        require => File['slurm CONFDIR'],
      }
    } else {
      concat { 'slurm.conf':
        ensure  => 'present',
        path    => $slurm_conf_path,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['slurm CONFDIR'],
      }

      concat::fragment { 'slurm.conf-common':
        target  => 'slurm.conf',
        content => template($slurm::slurm_conf_template),
        order   => '01',
      }

      concat::fragment { 'slurm.conf-partitions':
        target  => 'slurm.conf',
        content => template($slurm::partitionlist_template),
        order   => '03',
      }

      Concat::Fragment <<| tag == 'slurm_nodelist' |>>
    }

    file { 'plugstack.conf.d':
      ensure  => 'directory',
      path    => "${conf_dir}/plugstack.conf.d",
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => File['slurm CONFDIR'],
    }

    file { 'plugstack.conf':
      ensure  => 'file',
      path    => "${conf_dir}/plugstack.conf",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('slurm/plugstack.conf.erb'),
      require => File['slurm CONFDIR'],
    }
  }

  if $conf_dir != '/etc/slurm' {
    file { '/etc/slurm/slurm.conf':
      ensure  => 'link',
      path    => '/etc/slurm/slurm.conf',
      target  => $slurm_conf_path,
      owner   => 'root',
      group   => 'root',
    }

    file { '/etc/slurm/plugstack.conf.d':
      ensure  => 'link',
      path    => '/etc/slurm/plugstack.conf.d',
      target  => "${conf_dir}/plugstack.conf.d",
      owner   => 'root',
      group   => 'root',
    }

    file { '/etc/slurm/plugstack.conf':
      ensure  => 'link',
      path    => '/etc/slurm/plugstack.conf',
      target  => "${conf_dir}/plugstack.conf",
      owner   => 'root',
      group   => 'root',
    }
  }

  sysctl { 'net.core.somaxconn':
    ensure  => present,
    value   => '1024',
  }

}
