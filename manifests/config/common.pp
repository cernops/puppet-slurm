# == Class: slurm::config::common
#
class slurm::config::common (
  $slurm_user = 'slurm',
  $slurm_user_group = 'slurm',
  $log_dir = '/var/log/slurm',
  $pid_dir = '/var/run/slurm',
  $shared_state_dir = '/var/lib/slurm',
) {

  File {
    owner => $slurm_user,
    group => $slurm_user_group,
  }

  file { $log_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $pid_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $shared_state_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

}
