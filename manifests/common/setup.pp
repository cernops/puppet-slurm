# Private class
class slurm::common::setup {

  if $slurm::controller or $slurm::slurmdbd {
    $_dir_owner = $slurm::slurm_user
    $_dir_group = $slurm::slurm_user_group
  } else {
    $_dir_owner = $slurm::slurmd_user
    $_dir_group = $slurm::slurmd_user_group
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

  file { 'slurm CONFDIR':
    ensure => 'directory',
    path   => $slurm::conf_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Don't need these directories on a client - all other roles need them
  if $slurm::controller or $slurm::slurmdbd or $slurm::node {
    file { $slurm::log_dir:
      ensure => 'directory',
      owner  => $_dir_owner,
      group  => $_dir_group,
      mode   => '0700',
    }

    file { $slurm::pid_dir:
      ensure => 'directory',
      owner  => $_dir_owner,
      group  => $_dir_group,
      mode   => '0700',
    }

    file { $slurm::shared_state_dir:
      ensure => 'directory',
      owner  => $_dir_owner,
      group  => $_dir_group,
      mode   => '0700',
    }
  }

  if $slurm::manage_logrotate {
    #Refer to: http://slurm.schedmd.com/slurm.conf.html#SECTION_LOGGING
    logrotate::rule { 'slurm':
      path          => "${slurm::log_dir}/*.log",
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
      postrotate    => $slurm::_logrotate_postrotate,
    }
  }

  if $slurm::manage_rsyslog {
    if $slurm::node {
      rsyslog::snippet { '60_slurmd':
        ensure  => 'present',
        content => ":programname, isequal, \"slurmd\" -${::slurm::log_dir}/slurmd.log\n& stop",
      }
    }
    if $slurm::controller {
      rsyslog::snippet { '60_slurmctld':
        ensure  => 'present',
        content => ":programname, isequal, \"slurmctld\" -${::slurm::log_dir}/slurmctld.log\n& stop",
      }
    }
    if $slurm::slurmdbd {
      rsyslog::snippet { '60_slurmdbd':
        ensure  => 'present',
        content => ":programname, isequal, \"slurmdbd\" -${::slurm::log_dir}/slurmdbd.log\n& stop",
      }
    }
  }
}
