#
# slurm/dbnode/setup.pp
#   Creates folders/logfiles and installs packages specific to dbnode
#

class slurm::dbnode::setup (
  $jobacct_log = '/var/log/slurm_jobacct.log',
  $jobcomp_log = '/var/log/slurm_jobcomp.log',
  $packages = [
    'slurm',
    'slurm-devel',
    'slurm-plugins',
    'slurm-slurmdbd',
    'slurm-sql',
  ],
){

  ensure_packages($packages)

  file{ 'slurm job accounting log':
    ensure => file,
    path   => $jobacct_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  file{ 'slurm completed job log':
    ensure => file,
    path   => $jobcomp_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }
}
