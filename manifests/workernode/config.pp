#
# slurm/headnode/config.pp
#   create folders/logfiles for SLURM specific to workernode
#

class slurm::workernode::config (
    $slurmd_folder = '/var/spool/slurmd',
    $slurmd_log    = '/var/log/slurmd.log',
) {

  file{ 'slurmd folder':
    ensure => directory,
    path   => $slurmd_folder,
    group  => 'slurm',
    mode   => '1755',
    owner  => 'slurm',
  }

  file{ 'slurmd log':
    ensure => file,
    path   => $slurmd_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }
}
