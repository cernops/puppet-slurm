#
# slurm/headnode.pp
#   Puts SLURM on headnode
#

class slurm::headnode {

  include ::slurm::headnode::firewall
  include ::slurm::setup
  include ::slurm::headnode::setup
  include ::slurm::config
  include ::slurm::headnode::config

  Class['::slurm::setup']->
  Class['::slurm::headnode::setup']->
  Class['::slurm::config']->
  Class['::slurm::headnode::config']
}
