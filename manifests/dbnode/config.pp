# slurm/dbnode/config.pp
#
# Creates the slurmdb configuration file and ensures that the slurmdbd
# service is running and restarted if the configuration file is modified
#
# @param slurmdb_host
# @param slurmdb_port
# @param slurmuser
# @param db_host
# @param db_port
# @param db_user
# @param db_loc
#
# version 20170301
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::config (
  String $slurmdb_host  = 'dbnode.example.org',
  Integer $slurmdb_port = 6819,
  String $slurmuser     = 'slurm',
  String $db_host       = 'db_service.example.org',
  Integer $db_port      = 1234,
  String $db_user       = 'user',
  String $db_loc        = 'accountingdb',
) {

  teigi::secret::sub_file{ '/etc/slurm/slurmdbd.conf':
    teigi_keys => ['slurmdbpass'],
    content    => template('slurm/slurmdbd.conf.erb'),
    owner      => 'slurm',
    group      => 'slurm',
    mode       => '0644',
  }

  service{'slurmdbd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [Teigi_sub_file['/etc/slurm/slurmdbd.conf','/etc/slurm/slurm.conf'], Package['slurm-slurmdbd']],
  }
}
