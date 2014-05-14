# == Class: slurm::node
#
class slurm::node (
  $manage_slurm_conf = false,
  $manage_scripts = false,
  $with_devel = false,
  $manage_firewall = true,
  $manage_logrotate = true,
  $tmp_disk = '16000',
) {

  validate_bool($manage_slurm_conf)
  validate_bool($manage_scripts)
  validate_bool($with_devel)
  validate_bool($manage_firewall)
  validate_bool($manage_logrotate)

  $procs = $::physicalprocessorcount*$::corecountpercpu*$::threadcountpercore

  include slurm
  include slurm::user
  include slurm::munge
  if $slurm::use_auks { include slurm::auks }

  anchor { 'slurm::node::start': }
  anchor { 'slurm::node::end': }

  class { 'slurm::install':
    ensure          => $slurm::slurm_package_ensure,
    package_require => $slurm::package_require,
    use_pam         => $slurm::use_pam,
    with_devel      => $with_devel,
  }

  class { 'slurm::config::common':
    slurm_user        => $slurm::slurm_user,
    slurm_user_group  => $slurm::slurm_user_group,
    log_dir           => $slurm::log_dir,
    pid_dir           => $slurm::pid_dir,
    shared_state_dir  => $slurm::shared_state_dir,
  }

  class { 'slurm::config':
    manage_slurm_conf => $manage_slurm_conf,
  }

  class { 'slurm::node::config':
    manage_scripts    => $manage_scripts,
    manage_logrotate  => $manage_logrotate,
  }

  class { 'slurm::service':
    ensure  => 'running',
    enable  => true,
  }

  if $manage_firewall {
    firewall { '100 allow access to slurmd':
      proto   => 'tcp',
      dport   => $slurm::slurmd_port,
      action  => 'accept'
    }
  }

  @@concat_fragment { "slurm.conf+02-node-${::hostname}":
    tag     => 'slurm_nodelist',
    content => template('slurm/slurm.conf/slurm.conf.nodelist.erb'),
  }

  Anchor['slurm::node::start']->
  Class['slurm::user']->
  Class['slurm::munge']->
  Class['slurm::install']->
  Class['slurm::config::common']->
  Class['slurm::config']->
  Class['slurm::node::config']->
  Class['slurm::service']->
  Anchor['slurm::node::end']

}
