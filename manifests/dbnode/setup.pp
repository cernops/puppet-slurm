#
# slurm/dbnode/setup.pp
#   Creates folders/logfiles and installs packages specific to dbnode
#

class slurm::dbnode::setup (
  $jobacct_log = '/var/log/slurm/slurm_jobacct.log',
  $jobcomp_log = '/var/log/slurm/slurm_jobcomp.log',
  $slurmdbd_log = '/var/log/slurm/slurmdbd.log',
  $packages = [
    'slurm-plugins',
    'slurm-slurmdbd',
    'slurm-sql',
  ],
) {

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

  file{ 'slurmdbd log file':
    ensure => file,
    path   => $slurmdbd_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  logrotate::file{ 'slurm_jobacct':
    log => $jobacct_log,
    options => ['daily','copytruncate','rotate 7','compress'],
  }

  logrotate::file{ 'slurm_jobcomp':
    log => $jobcomp_log,
    options => ['daily','copytruncate','rotate 7','compress'],
  }

  logrotate::file{ 'slurmdbd':
    log => $slurmdbd_log,
    options => ['daily','copytruncate','rotate 7','compress'],
  }
}
