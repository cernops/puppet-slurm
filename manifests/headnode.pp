#
# slurm/headnode.pp
#
#

class slurm::headnode (
  $packages = [],
) {

  ensure_packages($packages)

  include ::slurm::headnode::config
}
