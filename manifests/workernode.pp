#
# slurm/workernode.pp
#   Puts SLURM on workernode
#

class slurm::workernode {

  include ::slurm::workernode::firewall
  include ::slurm::setup
  include ::slurm::workernode::setup
  include ::slurm::config
  include ::slurm::workernode::config

  Class['::slurm::setup']->
  Class['::slurm::workernode::setup']->
  Class['::slurm::config']->
  Class['::slurm::workernode::config']
}
