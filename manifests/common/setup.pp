# Private class
class slurm::common::setup {

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

  if $slurm::conf_dir != '/etc/slurm' {
    $etc_slurm_before = $slurm::manage_slurm_conf ? {
      true  => File['slurm CONFDIR'],
      false => undef,
    }

    file { '/etc/slurm':
      ensure  => 'link',
      target  => $slurm::conf_dir,
      force   => true,
      before  => $etc_slurm_before,
    }
  }

  if $slurm::manage_slurm_conf {
    file { 'slurm CONFDIR':
      ensure  => 'directory',
      path    => $slurm::conf_dir,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    }
  }

}
