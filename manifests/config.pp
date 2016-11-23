#
# slurm/config.pp
#   Creates the commun configuration file
#

class slurm::config (
  $scheduler_main_fqdn   = 'headnode1.example.org',
  $scheduler_backup_fqdn = 'headnode2.example.org',
  $checkpoint_dir        = '/var/slurm/checkpoint',
  $slurmkey_loc          = '/usr/local/slurm/slurm.key',
  $slurmcert_loc         = '/usr/local/slurm/slurm.cert',
  $maxjobcount           = '5000',
  $plugin_dir            = '/usr/lib64/slurm',
  $plugstackconf_file    = '/etc/slurm/plugstack.conf',
  $slurmctld_port        = '6817',
  $slurmd_port           = '6818',
  $slurmdspool_dir       = '/var/spool/slurmd',
  $slurmuser             = 'slurm',
  $scheduler_port        = '7321',
  $accounting_db_host    = 'accountingdb.example.org',
  $accounting_db_loc     = 'accountingdb',
  $accounting_db_port    = '1234',
  $accounting_db_user    = 'slurm',
  $clustername           = 'batch',
  $jobcomp_db_host       = 'jobcompdb.example.org',
  $jobcomp_db_loc        = 'jobcompdb',
  $jobcomp_db_port       = '1234',
  $jobcomp_db_user       = 'slurm',
  $slurmctld_log         = '/var/log/slurmctld.log',
  $slurmd_log            = '/var/log/slurmd.log',
  $workernodes           = [{'fqdn' => 'worker[00-10].example.org', 'cpu' => '16', 'memory' => '64000'}],
  $partitionname         = 'partition',
) {

  file{ 'common configuration file':
    ensure  => file,
    path    => '/etc/slurm/slurm.conf',
    content => template('slurm/slurm.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
  }
}
