# == Class: slurm::config::common
#
class slurm::config::common {

  include slurm

  File {
    owner => $slurm::slurm_user,
    group => $slurm::slurm_user_group,
  }

  file { $slurm::log_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $slurm::pid_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $slurm::shared_state_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

}
