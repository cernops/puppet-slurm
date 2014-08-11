# == Class: slurm::node
#
class slurm::node (
  $manage_slurm_conf = true,
  $manage_scripts = false,
  $with_devel = false,
  $install_torque_wrapper = true,
  $with_lua = false,
  $with_blcr = false,
  $install_blcr = false,
  $install_tools = false,
  $manage_blcr_service = false,
  $blcr_service_ensure = 'running',
  $blcr_service_enable = true,
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
  validate_bool($with_lua)
  validate_bool($with_blcr)
  validate_bool($install_blcr)
  validate_bool($install_tools)
  validate_bool($manage_blcr_service)
  validate_bool($manage_firewall)
  validate_bool($manage_logrotate)

  include ::munge
  include slurm
  include slurm::user
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
    with_lua                => $with_lua,
    with_blcr               => $with_blcr,
    install_blcr            => $install_blcr,
    install_tools           => $install_tools,
  }

  class { 'slurm::config':
    manage_slurm_conf => $manage_slurm_conf,
    manage_scripts    => $manage_scripts,
  }

  class { 'slurm::node::config':
    manage_logrotate  => $manage_logrotate,
  }

  class { 'slurm::service':
    ensure      => 'running',
    enable      => true,
    manage_blcr => $manage_blcr_service,
    blcr_ensure => $blcr_service_ensure,
    blcr_enable => $blcr_service_enable,
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
    tag     => $slurm::slurm_nodelist_tag,
  }

  Anchor['slurm::node::start']->
  Class['::munge']->
  Class['slurm::user']->
  Class['slurm::install']->
  Class['slurm::config::common']->
  Class['slurm::config']->
  Class['slurm::node::config']->
  Class['slurm::service']->
  Anchor['slurm::node::end']

}
