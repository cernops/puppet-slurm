# slurm/params.pp
#
# Handles distribution-specific parameters for slurm::config, slurm::setup,
# workernode::setup, headnode::setup, and dbnode::setup
#
# version 20171205
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::params(
  String $slurm_version = '17.02.6',
  ) {
  case $facts['os']['family'] {
    'RedHat': {
      $slurm_packages_common = [
        'slurm',
        'slurm-devel',
      ]
      $munge_packages = [
        'munge',
        'munge-libs',
        'munge-devel',
      ]
      $slurmdbd_packages_common = [
        'slurm-slurmdbd',
      ]
      $extra_packages = [
        'slurm-perlapi',
        'slurm-torque',
      ]

      if versioncmp($slurm_version, '17.2') <= 0 {
        $slurm_packages_old = ['slurm-munge', 'slurm-plugins']
        $slurmdbd_packages_old = ['slurm-sql']
        $slurmd_package = []
        $slurmctld_package = []
      } else {
        $slurm_packages_old = []
        $slurmdbd_packages_old = []
        $slurmd_package = ['slurm-slurmd']
        $slurmctld_package = ['slurm-slurmctld']
      }

    $slurm_packages = $slurm_packages_common + $slurm_packages_old
    $slurmdbd_packages = $slurmdbd_packages_common + $slurmdbd_packages_old

    }
    default: {
      fail("OS family type ${facts['os']['family']} not supported.")
    }
  }
}
