# == Class: slurm::service
#
class slurm::service {

  include slurm

  if $slurm::worker or $slurm::master {
    service { 'slurm':
      ensure      => running,
      enable      => true,
      hasstatus   => true,
      hasrestart  => true,
    }
  }

  if $slurm::slurmdb {
    service { 'slurmdbd':
      ensure      => running,
      enable      => true,
      hasstatus   => true,
      hasrestart  => true,
      require     => Class['mysql::server'],
    }
  }
}
