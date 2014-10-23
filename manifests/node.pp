# == Class: slurm::node
#
class slurm::node {

  include ::munge
  include slurm::common::user
  include slurm::common::install
  include slurm::node::config
  include slurm::common::setup
  include slurm::common::config
  include slurm::node::service

  anchor { 'slurm::node::start': }
  anchor { 'slurm::node::end': }

  if $slurm::include_blcr {
    include ::blcr

    Anchor['slurm::node::start']->
    Class['::munge']->
    Class['::blcr']->
    Class['slurm::common::user']->
    Class['slurm::common::install']->
    Class['slurm::node::config']->
    Class['slurm::common::setup']->
    Class['slurm::common::config']->
    Class['slurm::node::service']->
    Anchor['slurm::node::end']
  } else {
    Anchor['slurm::node::start']->
    Class['::munge']->
    Class['slurm::common::user']->
    Class['slurm::common::install']->
    Class['slurm::node::config']->
    Class['slurm::common::setup']->
    Class['slurm::common::config']->
    Class['slurm::node::service']->
    Anchor['slurm::node::end']
  }

  @@concat::fragment { "slurm.conf-node-${::hostname}":
    target  => 'slurm-nodes.conf',
    content => template('slurm/slurm.conf/slurm-node.conf.erb'),
    order   => '02',
    tag     => $slurm::slurm_nodelist_tag,
  }

  if $slurm::manage_firewall {
    firewall { '100 allow access to slurmd':
      proto  => 'tcp',
      dport  => $slurm::slurmd_port,
      action => 'accept'
    }
  }



}
