# slurm/dbnode/config.pp
#
# Creates the slurmdb configuration file and ensures that the slurmdbd
# service is running and restarted if the configuration file is modified
#
# @param dbd_host
# @param dbd_port
# @param slurm_user
# @param storage_host
# @param storage_port
# @param storage_user
# @param storage_loc
#
# version 20170306
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::config (
  String $dbd_host      = 'dbnode.example.org',
  Integer $dbd_port     = 6819,
  String $slurm_user    = 'slurm',
  String $storage_host  = 'db_instance.example.org',
  Integer $storage_port = 1234,
  String $storage_user  = 'user',
  String $storage_loc   = 'accountingdb',
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
