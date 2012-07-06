class slurm::master {
   include slurm::params
   class {'slurm::master::install':}
   class {'slurm::master::config':}
   class {'slurm::master::service':}
   class {'slurm::master::firewall':}
}
