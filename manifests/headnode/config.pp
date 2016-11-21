#
# slurm/headnode/config.pp
#   create folders/logfiles for SLURM specific to headnode
#

class slurm::headnode::config (
  $slurmctld_folder = '/var/spool/slurmctld',
  $slurmctld_log    = '/var/log/slurmctld.log',
  $slurmJobacct_log = '/var/log/slurm_jobacct.log',
  $slurmJobcomp_log = '/var/log/slurm_jobcomp.log',
){

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

  file{ 'slurm job accounting log':
    ensure => file,
    path   => $slurmJobacct_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  file{ 'slurm completed job log':
    ensure => file,
    path   => $slurmJobcomp_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }
}
