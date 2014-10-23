# Private class
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

  $node_fragment_content = template($slurm::node_template)
  $node_fragment_data    = {
    "${slurm::node_name}" => [ $node_fragment_content ],
  }

  @@datacat_fragment { "slurm.conf-node-${::hostname}":
    target => 'slurm-nodes.conf',
    data   => $node_fragment_data,
    tag    => $slurm::slurm_nodelist_tag,
  }

  if $slurm::manage_firewall {
    firewall { '100 allow access to slurmd':
      proto  => 'tcp',
      dport  => $slurm::slurmd_port,
      action => 'accept'
    }
  }



}
