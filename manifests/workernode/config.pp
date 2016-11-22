#
# slurm/config.pp
#
#

class slurm::workernode::config {

  service{'slurmd':
    ensure    => running,
    subscribe => File['common configuration file'],
  }
}
