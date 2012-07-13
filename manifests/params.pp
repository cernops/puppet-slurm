class slurm::params {
  $slurm_version = hiera('slurm_version')
  $slurm_user_uid = hiera('slurm_user_uid', 3000)
  # -> slurmctld.conf
  $slurm_master_hostname = hiera('slurm_master_hostname')
  $slurm_backup_hostname = hiera('slurm_backup_hostname')
  $slurmctld_port = hiera('slurmctld_port')
  $slurmd_port = hiera('slurmd_port')
  # -> slurmdbd.conf
  $slurmdbd_hostname = hiera('slurmdbd_hostname')
  $slurmdbd_port = hiera('slurmdbd_port')
  $slurmdbd_mysql_hostname = hiera('slurmdbd_mysql_hostname')
  $slurmdbd_mysql_port = hiera('slurmdbd_mysql_port', 3306)
  $slurmdbd_mysql_dbname = hiera('slurmdbd_mysql_dbname')
  $slurmdbd_mysql_user = hiera('slurmdbd_mysql_user')
  # Warning: this one is not hostgroup indep yet (common.yaml)
  $slurmdbd_mysql_passwd = hiera('slurmdbd_mysql_passwd')
  $slurm_partitionlist = hiera_array('partitions')
}
