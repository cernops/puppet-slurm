#
# slurm/workernode/config.pp
#   Ensures that the slurmd service is running and restarted if the
#   configuration file is modified
#

class slurm::workernode::config {

  # Starts slurmd on WN
  service{'slurmd':
    ensure     => running,
    enable     => true,
    has_status => true,
    subscribe  => [Teigi_sub_file['/etc/slurm/slurm.conf'], Package['slurm'],],
  }
}
