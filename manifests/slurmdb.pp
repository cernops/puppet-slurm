class slurm::slurmdb {
   include slurm::params
   class {'slurm::slurmdb::install':}
   class {'slurm::slurmdb::config':}
   class {'slurm::slurmdb::service':}
   class {'slurm::slurmdb::firewall':}
}
