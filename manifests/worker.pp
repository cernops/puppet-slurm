# == Class: slurm::worker
#
class slurm::worker {

  anchor { 'slurm::worker::start': }
  anchor { 'slurm::worker::end': }

  include slurm::user
  include slurm::munge
  include slurm::worker::install
  if $slurm::use_auks { include slurm::auks }
  include slurm::config
  include slurm::worker::config
  if $slurm::manage_firewall { include slurm::worker::firewall }
  include slurm::worker::service

  if $slurm::manage_firewall {
    Anchor['slurm::worker::start']->
    Class['slurm::user']->
    Class['slurm::munge']->
    Class['slurm::worker::install']->
    Class['slurm::config']->
    Class['slurm::worker::config']->
    Class['slurm::worker::firewall']->
    Class['slurm::worker::service']->
    Anchor['slurm::worker::end']
  } else {
    Anchor['slurm::worker::start']->
    Class['slurm::user']->
    Class['slurm::munge']->
    Class['slurm::worker::install']->
    Class['slurm::config']->
    Class['slurm::worker::config']->
    Class['slurm::worker::service']->
    Anchor['slurm::worker::end']
  }

}
