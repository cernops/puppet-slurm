#
# slurm/headnode/setup.pp
#   Creates folders/logfiles and installs packages specific to headnode
#

class slurm::headnode::setup (
  $slurmctld_folder   = '/var/spool/slurmctld',
  $slurm_state_folder = '/var/spool/slurmctld/slurm.state',
  $slurmctld_log      = '/var/log/slurmctld.log',
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
    require => User['slurm'],
  }

  file{ 'slurmctld state folder':
    ensure => directory,
    path   => $slurm_state_folder,
    group  => 'slurm',
    mode   => '1755',
    owner  => 'slurm',
    require => File['slurmctld folder'],
  }

  file{ '/var/spool/slurmctld/slurm.state/clustername':
    ensure  => file,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => File['slurmctld state folder'],
  }

  file{ 'slurmctld log':
    ensure => file,
    path   => $slurmctld_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
    require => User['slurm'],
  }

}
