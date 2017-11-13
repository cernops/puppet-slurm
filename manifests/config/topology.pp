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
  Array[Hash[String, String]] $switches,
  Optional[String] $autodiscover = undef,
) {

  # Either the topology is autodiscovered through a fact,
  # (we currently only support infiniband autodiscovery)
  # or we use the topology supplied by hiera
  case $autodiscover {
    'infiniband': {
      $switches = $facts['infiniband_topology']
    }
  }

  # Topology file
  file{'/etc/slurm/topology.conf':
    ensure  => file,
    content => template('slurm/topology.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }

}
