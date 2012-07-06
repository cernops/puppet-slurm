class slurm::worker {
   include slurm::params
   class {'slurm::worker::install':}
   class {'slurm::worker::config':}
   class {'slurm::worker::service':}
   class {'slurm::worker::firewall':}
}
