#
# slurm/init.pp
#   Installs SLURM with configuration according
#

class slurm (
  $machine_type = '',
){

  case $machine_type {
    'worker': {
      class{'::slurm::workernode':}
    }
    'head': {
      class{'::slurm::headnode':}
    }
    default: {
      error('No role specified! Please provide one in hiera.')
    }
  }
}
