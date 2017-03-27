# slurm/dbnode/config.pp
#
# Creates the slurmdb configuration file and ensures that the slurmdbd
# service is running and restarted if the configuration file is modified
#
# @param dbd_host The short, or long, name of the machine where the Slurm Database Daemon is executed
# @param dbd_port The port number that the Slurm Database Daemon (slurmdbd) listens to for work
# @param slurm_user The name of the user that the slurmctld daemon executes as
# @param storage_host Define the name of the host the database is running where we are going to store the data
# @param storage_port The port number that the Slurm Database Daemon (slurmdbd) communicates with the database
# @param storage_user Define the name of the user we are going to connect to the database with to store the job accounting data
# @param storage_loc Specify the name of the database as the location where accounting records are written
#
# version 20170327
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::config (
  String $dbd_host      = 'localhost',
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
    subscribe => [
      Package['slurm-slurmdbd'],
      Teigi_sub_file[
        '/etc/slurm/slurmdbd.conf',
        '/etc/slurm/slurm.conf',
      ],
      File[
        '/etc/slurm/cgroup.conf',
        '/etc/slurm/plugstack.conf',
      ],
    ],
  }
}
