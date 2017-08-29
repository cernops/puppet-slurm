# slurm/dbnode/setup.pp
#
# Creates folders/logfiles and installs packages specific to dbnode.
#
# @param packages Packages to install.
#
# version 20170829
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::setup (
  Array[String] $slurmdbd_packages = $slurm::params::slurmdbd_packages,
) inherits slurm::params {

  ensure_packages($slurmdbd_packages, {'ensure' => $slurm::setup::slurm_version})

}
