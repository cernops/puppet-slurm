# == Class: slurm::slurmdbd
#
class slurm::slurmdbd {

  anchor { 'slurm::slurmdbd::start': }
  anchor { 'slurm::slurmdbd::end': }

  include slurm::user
  include slurm::munge
  include slurm::slurmdbd::install
  include slurm::config
  include slurm::slurmdbd::config
  if $slurm::manage_firewall { include slurm::slurmdbd::firewall }
  include slurm::slurmdbd::service

  if $slurm::manage_firewall {
    Anchor['slurm::slurmdbd::start']->
    Class['slurm::user']->
    Class['slurm::munge']->
    Class['slurm::slurmdbd::install']->
    Class['slurm::config']->
    Class['slurm::slurmdbd::config']->
    Class['slurm::slurmdbd::firewall']->
    Class['slurm::slurmdbd::service']->
    Anchor['slurm::slurmdbd::end']
  } else {
    Anchor['slurm::slurmdbd::start']->
    Class['slurm::user']->
    Class['slurm::munge']->
    Class['slurm::slurmdbd::install']->
    Class['slurm::config']->
    Class['slurm::slurmdbd::config']->
    Class['slurm::slurmdbd::service']->
    Anchor['slurm::slurmdbd::end']
  }

}
