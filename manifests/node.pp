# == Class: slurm::node
#
class slurm::node (
  $manage_slurm_conf = true,
  $manage_scripts = false,
  $with_devel = false,
  $install_torque_wrapper = true,
  $install_tools = false,
  $manage_firewall = true,
  $manage_logrotate = true,
  $node_name = $::hostname,
  $node_addr = $::ipaddress,
  $cpus = $::processorcount,
  $sockets = 'UNSET',
  $cores_per_socket = 'UNSET',
  $threads_per_core = 'UNSET',
  $real_memory = $::real_memory,
  $tmp_disk = '16000',
  $feature = 'UNSET',
  $state = 'UNKNOWN',
) {

  validate_bool($manage_slurm_conf)
  validate_bool($manage_scripts)
  validate_bool($with_devel)
  validate_bool($install_torque_wrapper)
  validate_bool($manage_firewall)
  validate_bool($manage_logrotate)

  include slurm
  include slurm::user
  include slurm::munge
  include slurm::config::common
  if $slurm::use_auks { include slurm::auks }

  anchor { 'slurm::node::start': }
  anchor { 'slurm::node::end': }

  class { 'slurm::install':
    ensure                  => $slurm::slurm_package_ensure,
    package_require         => $slurm::package_require,
    use_pam                 => $slurm::use_pam,
    with_devel              => $with_devel,
    install_torque_wrapper  => $install_torque_wrapper,
    install_tools           => $install_tools,
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

  @@concat::fragment { "slurm.conf-node-${::hostname}":
    target  => 'slurm.conf',
    content => template('slurm/slurm.conf/slurm.conf.nodelist.erb'),
    order   => '02',
    tag     => 'slurm_nodelist',
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
