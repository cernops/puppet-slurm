#
# slurm/workernode.pp
#
#

class slurm::workernode (
  $packages = [],
) {

  ensure_packages($packages)

  include ::slurm::workernode::config
}
