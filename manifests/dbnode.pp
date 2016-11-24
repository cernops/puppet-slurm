#
# slurm/dbnode.pp
#   Puts SLURM on dbnode
#

class slurm::dbnode {

  class{'::slurm::dbnode::firewall':}
  class{'::slurm::setup':}->
  class{'::slurm::dbnode::setup':}->
  class{'::slurm::config':}->
  class{'::slurm::dbnode::config':}
}
