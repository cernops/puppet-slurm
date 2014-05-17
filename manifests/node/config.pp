# == Class: slurm::node::config
#
class slurm::node::config (
  $manage_scripts = false,
  $manage_logrotate = true,
) {

  include slurm

  File {
    owner => $slurm::slurmd_user,
    group => $slurm::slurmd_user_group,
  }

  file { 'SlurmdSpoolDir':
    ensure  => 'directory',
    path    => $slurm::slurmd_spool_dir,
    mode    => '0755',
  }

  limits::limits { 'unlimited_memlock':
    ensure      => 'present',
    user        => '*',
    limit_type  => 'memlock',
    hard        => 'unlimited',
    soft        => 'unlimited',
  }

  if $slurm::epilog and $manage_scripts {
    file { 'epilog':
      ensure  => 'file',
      path    => $slurm::epilog,
      source  => $slurm::epilog_source,
      mode    => '0754',
    }
  }

  if $slurm::health_check_program and $manage_scripts {
    file { 'health_check_program':
      ensure  => 'file',
      path    => $slurm::health_check_program,
      source  => $slurm::health_check_program_source,
      mode    => '0754',
    }
  }

  if $slurm::prolog and $manage_scripts {
    file { 'prolog':
      ensure  => 'file',
      path    => $slurm::prolog,
      source  => $slurm::prolog_source,
      mode    => '0754',
    }
  }

  if $slurm::task_epilog and $manage_scripts {
    file { 'task_epilog':
      ensure  => 'file',
      path    => $slurm::task_epilog,
      source  => $slurm::task_epilog_source,
      mode    => '0754',
    }
  }

  if $slurm::task_prolog and $manage_scripts {
    file { 'task_prolog':
      ensure  => 'file',
      path    => $slurm::task_prolog,
      source  => $slurm::task_prolog_source,
      mode    => '0754',
    }
  }

  if $manage_logrotate {
    #Refer to: http://slurm.schedmd.com/slurm.conf.html#lbAJ
    logrotate::rule { 'slurmd':
      path          => $slurm::slurmd_log_file,
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

}
