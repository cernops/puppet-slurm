#
# slurm/dbnode/config.pp
#   Creates the slurmdb configuration file and ensures that the slurmdbd
#   service is running and restarted if the configuration file is modified
#

class slurm::dbnode::config (
  $slurmdb_host   = 'dbnode.example.org',
  $slurmdb_port   = '6819',
  $slurmuser      = 'slurm',
  $db_host        = 'db_service.example.org',
  $db_port        = '1234',
  $db_user        = 'user',
  $db_loc         = 'accountingdb',
) {

  teigi::secret::sub_file{ '/etc/slurm/slurmdbd.conf':
    teigi_keys => ['slurmdbpass'],
    template   => 'slurm/slurmdbd.conf.erb',
    owner      => 'slurm',
    group      => 'slurm',
    mode       => '0644',
  }

  #service{'slurmdbd':
  #  ensure     => running,
  #  enable     => true,
  #  has_status => true,
  #  subscribe  => [Teigi_sub_file['/etc/slurm/slurmdbd.conf','/etc/slurm/slurmdbd.conf'], Package['slurm-slurmdbd'],],
  #}
}
