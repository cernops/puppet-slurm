# == Class: slurm::client
#
class slurm::client {

  anchor { 'slurm::client::start': }
  anchor { 'slurm::client::end': }

  include slurm::user
  include slurm::munge
  if $slurm::use_auks { include slurm::auks }
  include slurm::client::install
  include slurm::client::config
  include slurm::client::service

  Anchor['slurm::client::start']->
  Class['slurm::user']->
  Class['slurm::munge']->
  Class['slurm::client::install']->
  Class['slurm::client::config']->
  Class['slurm::client::service']->
  Anchor['slurm::client::end']

}
