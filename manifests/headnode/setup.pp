#
# slurm/headnode/setup.pp
#   Creates folders/logfiles and installs packages specific to headnode
#

class slurm::headnode::setup (
  $slurmctld_folder = '/var/spool/slurmctld',
  $slurmctld_log    = '/var/log/slurmctld.log',
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

  file{ 'slurmctld folder':
    ensure => directory,
    path   => $slurmctld_folder,
    group  => 'slurm',
    mode   => '1755',
    owner  => 'slurm',
  }

  file{ 'slurmctld log':
    ensure => file,
    path   => $slurmctld_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }
}
