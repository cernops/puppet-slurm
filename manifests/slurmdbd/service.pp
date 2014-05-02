# == Class: slurm::slurmdbd::service
#
class slurm::slurmdbd::service {

  service { 'slurmdbd':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
    #require     => Class['mysql::server'],
  }

}
