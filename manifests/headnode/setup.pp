# slurm/headnode/setup.pp
#
# Creates folders/logfiles and installs packages specific to headnode
#
# @param slurmctld_spool_dir Fully qualified pathname of a directory into which the slurmctld daemon's state information and batch job script information are written
# @param slurmctld_log_file Fully qualified pathname of a file into which the slurmctld daemon's logs are written
# @param packages Packages to install
#
# version 20170829
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::headnode::setup (
  String $state_save_location = $slurm::config::state_save_location,
  Optional[String] $slurmctld_log_file = $slurm::config::slurmctld_log_file,
  Array[String] $extra_packages = $slurm::params::extra_packages,
) inherits slurm::params {

  ensure_packages($extra_packages, {'ensure' => $slurm::params::slurm_version})
  ensure_packages($slurm::params::slurmctld_package, {'ensure' => $slurm::params::slurm_version})

  file{ dirtree($slurm::config::state_save_location, $slurm::config::state_save_location) :
    ensure  => directory,
  }
  -> file{ 'slurm state save location folder':
    ensure  => directory,
    path    => $slurm::config::state_save_location,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }

  if ($slurmctld_log_file != undef) {
    file{ dirtree($slurmctld_log_file, $slurmctld_log_file) :
      ensure  => directory,
    }
    -> file{ 'slurmctld log':
      ensure  => file,
      path    => $slurmctld_log_file,
      group   => 'slurm',
      mode    => '0600',
      owner   => 'slurm',
      require => User['slurm'],
    }
    -> logrotate::file{ 'slurmctld':
      log     => $slurmctld_log_file,
      options => ['weekly','copytruncate','rotate 26','compress'],
    }
  }
}
