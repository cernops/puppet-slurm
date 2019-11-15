# Private class
class slurm::node {

  contain ::munge
  contain slurm::common::user
  contain slurm::common::install
  contain slurm::common::setup
  contain slurm::common::config
  contain slurm::node::config
  contain slurm::node::service

  Class['::munge']
  -> Class['slurm::common::user']
  -> Class['slurm::common::install']
  -> Class['slurm::common::setup']
  -> Class['slurm::common::config']
  -> Class['slurm::node::config']
  ~> Class['slurm::node::service']

  Class['slurm::common::install']
  ~> Class['slurm::node::service']

  Class['slurm::common::setup']
  ~> Class['slurm::node::service']

  Class['slurm::common::config']
  ~> Class['slurm::node::service']

  @@slurm::node::conf { $::slurm::node_name:
    * => $::slurm::node_conf,
  }

  if $slurm::manage_firewall {
    firewall { '100 allow access to slurmd':
      proto  => 'tcp',
      dport  => $slurm::slurmd_port,
      action => 'accept'
    }
  }

}
