#
# slurm/workernode.pp
#   Puts SLURM on workernode
#

class slurm::workernode {

  class{'::slurm::auks':}
  class{'::slurm::setup':}->
  class{'::slurm::workernode::setup':}->
  class{'::slurm::config':}->
  class{'::slurm::workernode::config':}->
  class{'::slurm::install':}
}
