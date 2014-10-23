# == Class: slurm::client
#
class slurm::client {

  include ::munge
  include slurm::common::install
  include slurm::common::setup
  include slurm::common::config
  include slurm::client::service

  anchor { 'slurm::client::start': }
  anchor { 'slurm::client::end': }

  Anchor['slurm::client::start']->
  Class['::munge']->
  Class['slurm::common::install']->
  Class['slurm::common::setup']->
  Class['slurm::common::config']->
  Class['slurm::client::service']->
  Anchor['slurm::client::end']

}
