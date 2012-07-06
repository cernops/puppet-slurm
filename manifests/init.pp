# Being of class 'slurm' means that the machine is prepared
# for being either a master or a worker node. For the moment,
# the only way to configure a machine to act as any of them is
# by adding it to slurm::master or slurm::worker manually.
class slurm inherits slurm::params {
   class {'slurm::install':}
   class {'slurm::config':}
   class {'slurm::service':}
}
