# == Class: slurm::config::common
#
class slurm::config::common {

  include slurm

  if $slurm::conf_dir != '/etc/slurm' {
    file { '/etc/slurm':
      ensure  => 'link',
      target  => $slurm::conf_dir,
      force   => true,
      before  => File['slurm CONFDIR'],
    }
  }

  file { 'slurm CONFDIR':
    ensure  => 'directory',
    path    => $slurm::conf_dir,
    owner   => $slurm::slurm_user,
    group   => $slurm::slurm_user_group,
    mode    => '0755',
  }

  file { $slurm::log_dir:
    ensure  => 'directory',
    owner   => $slurm::slurm_user,
    group   => $slurm::slurm_user_group,
    mode    => '0700',
  }

  file { $slurm::pid_dir:
    ensure  => 'directory',
    owner   => $slurm::slurm_user,
    group   => $slurm::slurm_user_group,
    mode    => '0700',
  }

  file { $slurm::shared_state_dir:
    ensure  => 'directory',
    owner   => $slurm::slurm_user,
    group   => $slurm::slurm_user_group,
    mode    => '0700',
  }

}
