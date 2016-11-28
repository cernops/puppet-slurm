#
# slurm/config.pp
#   Creates the slurmdb configuration file and ensures that the
#   slurmdb daemon are restarted if the configuration files are modified
#

class slurm::dbnode::config (
  $slurmdb_host   = 'dbnode.example.org',
  $slurmdb_port   = '6819',
  $slurmuser      = 'slurm',
  $db_host        = 'db_service.example.org',
  $dp_port        = '1234',
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
  service{'slurmdb':
    ensure    => running,
    subscribe => Teigi_sub_file['/etc/slurm/slurmdbd.conf','/etc/slurm/slurmdbd.conf'],
  }
}
