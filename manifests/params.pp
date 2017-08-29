# slurm/params.pp
#
# Handles distribution-specific parameters for slurm::config, slurm::setup,
# workernode::setup, headnode::setup, and dbnode::setup
#
# version 20170829
# 
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::params {
  case $facts['os']['family'] {
    'RedHat': {
      $slurm_packages = [
        'slurm',
        'slurm-devel',
        'slurm-munge',
        'slurm-plugins',
      ]
      $munge_packages = [
        'munge',
        'munge-libs',
        'munge-devel',
      ]
      $slurmdbd_packages = [
        'slurm-slurmdbd',
        'slurm-sql',
      ]
      $extra_packages = [
        'slurm-perlapi',
        'slurm-torque',
      ]
    }
    default: {
      fail("OS family type ${facts['os']['family']} not supported.")
    }
  }
}
