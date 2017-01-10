#
# slurm/workernode/setup.pp
#   Creates folders/logfiles and installs packages specific to workernode
#

class slurm::workernode::setup (
  $slurmd_folder = '/var/spool/slurmd',
  $slurmd_log    = '/var/log/slurm/slurmd.log',
  $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-sjobexit',
    'slurm-sjstat',
    'slurm-torque',
  ],
) {

  ensure_packages($packages)

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

  logrotate::file{ 'slurmd':
    log     => $slurmd_log,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }
}
