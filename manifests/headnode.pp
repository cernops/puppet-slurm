#
# slurm/headnode.pp
#   Puts SLURM on headnode
#

class slurm::headnode {

  class{'::slurm::firewall':}
  class{'::slurm::auks':}
  class{'::slurm::setup':}->
  class{'::slurm::headnode::setup':}->
  class{'::slurm::config':}->
  class{'::slurm::headnode::config':}->
  class{'::slurm::install':}
}
