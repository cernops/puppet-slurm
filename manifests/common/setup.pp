# Private class
class slurm::common::setup {

  if $slurm::controller or $slurm::slurmdbd {
    $_dir_owner = $slurm::slurm_user
    $_dir_group = $slurm::slurm_user_group
  } else {
    $_dir_owner = $slurm::slurmd_user
    $_dir_group = $slurm::slurmd_user_group
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

}
