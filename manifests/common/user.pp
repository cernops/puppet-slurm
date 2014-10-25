# Private class
class slurm::common::user {

  if $slurm::manage_slurm_user {
    group { 'slurm':
      ensure => present,
      name   => $slurm::slurm_user_group,
      gid    => $slurm::slurm_group_gid,
    }

    user { 'slurm':
      ensure     => present,
      name       => $slurm::slurm_user,
      uid        => $slurm::slurm_user_uid,
      gid        => $slurm::slurm_user_group,
      shell      => $slurm::slurm_user_shell,
      home       => $slurm::slurm_user_home,
      managehome => false,
      comment    => $slurm::slurm_user_comment,
      before     => File[$slurm::slurm_user_home]
    }
  }

  if $slurm::manage_slurm_user or $slurm::manage_slurm_conf {
    file { $slurm::slurm_user_home:
      ensure => 'directory',
      mode   => '0755',
    }
  }

}
