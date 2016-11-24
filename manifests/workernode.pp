#
# slurm/workernode.pp
#   Puts SLURM on workernode
#

class slurm::workernode {

  class{'::slurm::workernode::firewall':}
  class{'::slurm::setup':}->
  class{'::slurm::workernode::setup':}->
  class{'::slurm::config':}->
  class{'::slurm::workernode::config':}
}
