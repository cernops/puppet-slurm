# == Class: slurm::config
#
class slurm::config (
  $manage_slurm_conf = true,
  $manage_scripts = true,
) {

  include slurm

  $partitionlist    = $slurm::partitionlist
  $slurm_conf       = $slurm::slurm_conf
  $conf_dir         = $slurm::conf_dir
  $slurm_conf_path  = $slurm::slurm_conf_path

  if $conf_dir != '/etc/slurm' {
    file { '/etc/slurm':
      ensure  => 'link',
      target  => $conf_dir,
      before  => File['slurm CONFDIR'],
    }
  }

  file { 'slurm CONFDIR':
    ensure  => 'directory',
    path    => $conf_dir,
    owner   => $slurm::slurm_user,
    group   => $slurm::slurm_user_group,
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
    content => template($slurm::slurm_sh_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/profile.d/slurm.csh':
    ensure  => 'file',
    path    => '/etc/profile.d/slurm.csh',
    content => template($slurm::slurm_csh_template),
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
        ensure          => 'present',
        path            => $slurm_conf_path,
        owner           => 'root',
        group           => 'root',
        mode            => '0644',
        ensure_newline  => true,
        require         => File['slurm CONFDIR'],
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

  if $manage_scripts {
    if $slurm::epilog {
      file { 'epilog':
        ensure  => 'file',
        path    => $slurm::epilog,
        source  => $slurm::epilog_source,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
      }
    }

    if $slurm::health_check_program {
      file { 'health_check_program':
        ensure  => 'file',
        path    => $slurm::health_check_program,
        source  => $slurm::health_check_program_source,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
      }
    }

    if $slurm::prolog {
      file { 'prolog':
        ensure  => 'file',
        path    => $slurm::prolog,
        source  => $slurm::prolog_source,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
      }
    }

    if $slurm::task_epilog {
      file { 'task_epilog':
        ensure  => 'file',
        path    => $slurm::task_epilog,
        source  => $slurm::task_epilog_source,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
      }
    }

    if $slurm::task_prolog {
      file { 'task_prolog':
        ensure  => 'file',
        path    => $slurm::task_prolog,
        source  => $slurm::task_prolog_source,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
      }
    }
  }

  sysctl { 'net.core.somaxconn':
    ensure  => present,
    value   => '1024',
  }

}
