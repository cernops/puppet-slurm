# slurm/config/gres.pp
#
# Creates the cgroup configuration files.
#
# @param gres_definitions Contains a Hash with GRES resource definitions
#
# version 20190405
#
# Copyright (c) PSI (Paul Scherrer Institute), CERN, 2019
# Authors: - Marc Caubet Serrabou <marc.caubet@psi.ch>
# License: GNU GPL v3 or later.
#

class slurm::config::gres (
  String $ensure,
  Array[Hash,1] $gres_definitions,
) {

  # Cgroup configuration
  file{ '/etc/slurm/gres.conf':
    ensure  => $ensure,
    content => template('slurm/gres.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }
}
