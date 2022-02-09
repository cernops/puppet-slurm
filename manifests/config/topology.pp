# slurm/config/topology.pp
#
# Creates the topology configuration files.
#
# @param switches Array of hashes containing the information about the topology.
#
# version 20170816
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::config::topology (
  String $ensure,
  Array[Hash[String, String]] $switches,
) {

  # Topology file
  file{'/etc/slurm/topology.conf':
    ensure  => $ensure,
    content => template('slurm/topology.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }

}
