#
# slurm/dbnode.pp
#   Puts SLURM on dbnode
#

class slurm::dbnode {

  include ::slurm::dbnode::firewall
  include ::slurm::setup
  include ::slurm::dbnode::setup
  include ::slurm::config
  include ::slurm::dbnode::config

  Class['::slurm::setup']->
  Class['::slurm::dbnode::setup']->
  Class['::slurm::config']->
  Class['::slurm::dbnode::config']
}
