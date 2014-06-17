# == Class: slurm::user
#
class slurm::user {

  include slurm

  if $slurm::manage_slurm_user {
    group { 'slurm':
      ensure  => present,
      name    => $slurm::slurm_user_group,
      gid     => $slurm::gid,
    }

    user { 'slurm':
      ensure      => present,
      name        => $slurm::slurm_user,
      uid         => $slurm::uid,
      gid         => $slurm::slurm_user_group,
      shell       => $slurm::slurm_user_shell,
      home        => $slurm::slurm_user_home,
      managehome  => $slurm::slurm_user_managehome,
      comment     => $slurm::slurm_user_comment,
      before      => File[$slurm::slurm_user_home],
    }
  }

  # TODO: Find better way to manage user and home directory
  # with correct permissions if used as global conf location
  file { $slurm::slurm_user_home:
    ensure  => 'directory',
    owner   => $slurm::slurm_user,
    group   => $slurm::slurm_user_group,
    mode    => '0755',
  }

}
