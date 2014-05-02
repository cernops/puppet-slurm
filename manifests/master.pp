# == Class: slurm::master
#
class slurm::master {

  anchor { 'slurm::master::start': }
  anchor { 'slurm::master::end': }

  include slurm::munge
  include slurm::master::install
  if $slurm::use_auks { include slurm::auks }
  include slurm::master::config
  if $slurm::manage_firewall { include slurm::master::firewall }
  include slurm::master::service

  if $slurm::manage_firewall {
    Anchor['slurm::master::start']->
    Class['slurm::munge']->
    Class['slurm::master::install']->
    Class['slurm::master::config']->
    Class['slurm::master::firewall']->
    Class['slurm::master::service']->
    Anchor['slurm::master::end']
  } else {
    Anchor['slurm::master::start']->
    Class['slurm::munge']->
    Class['slurm::master::install']->
    Class['slurm::master::config']->
    Class['slurm::master::service']->
    Anchor['slurm::master::end']
  }

}
