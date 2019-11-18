# @api private
class slurm::common::setup {

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
  if ('slurmd' in $slurm::roles) or ('slurmctld' in $slurm::roles) or ('slurmdbd' in $slurm::roles) {
    file { $slurm::log_dir:
      ensure => 'directory',
      owner  => $slurm::slurm_user,
      group  => $slurm::slurm_user_group,
      mode   => '0700',
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
      if 'slurmd' in $slurm::roles {
        rsyslog::snippet { '60_slurmd':
          ensure  => 'present',
          content => ":programname, isequal, \"slurmd\" -${::slurm::log_dir}/slurmd.log\n& stop",
        }
      }
      if 'slurmctld' in $slurm::roles {
        rsyslog::snippet { '60_slurmctld':
          ensure  => 'present',
          content => ":programname, isequal, \"slurmctld\" -${::slurm::log_dir}/slurmctld.log\n& stop",
        }
      }
      if 'slurmdbd' in $slurm::roles {
        rsyslog::snippet { '60_slurmdbd':
          ensure  => 'present',
          content => ":programname, isequal, \"slurmdbd\" -${::slurm::log_dir}/slurmdbd.log\n& stop",
        }
      }
    }
  }
}
