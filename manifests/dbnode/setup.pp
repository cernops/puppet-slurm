#
# slurm/dbnode/setup.pp
#   Creates folders/logfiles and installs packages specific to dbnode
#

class slurm::dbnode::setup (
  $slurmJobacct_log = '/var/log/slurm_jobacct.log',
  $slurmJobcomp_log = '/var/log/slurm_jobcomp.log',
  $packages      = [],
){

  ensure_packages($packages)

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
