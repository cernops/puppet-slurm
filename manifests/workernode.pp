#
# slurm/workernode.pp
#
#

class slurm::workernode {

  class{'::slurm::firewall':}
  class{'::slurm::auks':}
  class{'::slurm::config':}->
  class{'::slurm::workernode::config':}->
  class{'::slurm::install':}
}
