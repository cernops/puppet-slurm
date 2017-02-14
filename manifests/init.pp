#
# slurm/init.pp
#   Installs SLURM with configuration according to role
#

class slurm (
  $node_type = '',
) {

  case $node_type {
    'worker': {
      class{'::slurm::workernode':}
    }
    'head': {
      class{'::slurm::headnode':}
    }
    'db': {
      class{'::slurm::dbnode':}
    }
    'db-head': {
      class{'::slurm::headnode':}
      class{'::slurm::dbnode':}
    }
    default: {}
  }
}
