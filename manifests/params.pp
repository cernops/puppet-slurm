class slurm::params {
  $slurm_version = hiera('slurm_version', '2.3.5-2.ai6')
  $slurm_user_uid = hiera('slurm_user_uid', 3000)
  # -> slurmctld.conf
  $slurm_master_hostname = hiera('slurm_master_hostname', 'master.example.org')
  $slurm_backup_hostname = hiera('slurm_backup_hostname', 'slave.example.org')
  $slurmctld_port = hiera('slurmctld_port', '6810-6817')
  $slurmd_port = hiera('slurmd_port', 6818)
  # -> slurmdbd.conf
  $slurmdbd_hostname = hiera('slurmdbd_hostname', 'db.example.org')
  $slurmdbd_port = hiera('slurmdbd_port', 6819)
  $slurmdbd_mysql_hostname = hiera('slurmdbd_mysql_hostname', 'localhost')
  $slurmdbd_mysql_port = hiera('slurmdbd_mysql_port', 3306)
  $slurmdbd_mysql_dbname = hiera('slurmdbd_mysql_dbname', 'slurm')
  $slurmdbd_mysql_user = hiera('slurmdbd_mysql_user', 'slurm')
  $slurmdbd_mysql_passwd = hiera('slurmdbd_mysql_passwd', 'slurm')
  $slurm_partitionlist = hiera('partitions', '[]')
  $slurm_worker_slot_multiplier = hiera('slurm_worker_slot_multiplier', 1)
  $slurm_fastschedule = hiera('slurm_fastschedule', 2)
}
