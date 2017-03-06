# slurm/dbnode/setup.pp
#
# Creates folders/logfiles and installs packages specific to dbnode
#
# @param job_accounting_log
# @param job_completion_log
# @param slurmdbd_log_file
# @param packages
#
# version 20170306
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::setup (
  String $job_accounting_log = '/var/log/slurm/slurm_jobacct.log',
  String $job_completion_log = '/var/log/slurm/slurm_jobcomp.log',
  String $slurmdbd_log_file  = '/var/log/slurm/slurmdbd.log',
  Array $packages = [
    'slurm-plugins',
    'slurm-slurmdbd',
    'slurm-sql',
  ],
) {

  ensure_packages($packages)

  file{ 'slurm job accounting log':
    ensure => file,
    path   => $job_accounting_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  file{ 'slurm completed job log':
    ensure => file,
    path   => $job_completion_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  file{ 'slurmdbd log file':
    ensure => file,
    path   => $slurmdbd_log_file,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  logrotate::file{ 'slurm_jobacct':
    log     => $job_accounting_log,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }

  logrotate::file{ 'slurm_jobcomp':
    log     => $job_completion_log,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }

  logrotate::file{ 'slurmdbd':
    log     => $slurmdbd_log_file,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }
}
