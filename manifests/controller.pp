# Private class
class slurm::controller {

  include ::munge
  include slurm::common::user
  include slurm::common::install
  include slurm::controller::config
  include slurm::common::setup
  include slurm::common::config
  include slurm::controller::service

  anchor { 'slurm::controller::start': }
  anchor { 'slurm::controller::end': }

  if $slurm::include_blcr {
    include ::blcr

    Anchor['slurm::controller::start']->
    Class['::munge']->
    Class['::blcr']->
    Class['slurm::common::user']->
    Class['slurm::common::install']->
    Class['slurm::controller::config']->
    Class['slurm::common::setup']->
    Class['slurm::common::config']->
    Class['slurm::controller::service']->
    Anchor['slurm::controller::end']
  } else {
    Anchor['slurm::controller::start']->
    Class['::munge']->
    Class['slurm::common::user']->
    Class['slurm::common::install']->
    Class['slurm::controller::config']->
    Class['slurm::common::setup']->
    Class['slurm::common::config']->
    Class['slurm::controller::service']->
    Anchor['slurm::controller::end']
  }

  if $slurm::manage_firewall {
    firewall { '100 allow access to slurmctld':
      proto   => 'tcp',
      dport   => $slurm::slurmctld_port,
      action  => 'accept'
    }
  }

}
