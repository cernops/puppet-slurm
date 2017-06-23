# slurm/dbnode/config.pp
#
# Creates the slurmdb configuration file and ensures that the slurmdbd service is running and restarted if the configuration file is modified.
#
# For details about the parameters, please refer to the SLURM documentation at https://slurm.schedmd.com/slurmdbd.conf.html
#
# version 20170623
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::config (
  String[1,default] $file_name = 'slurmdbd.conf',
  String[1,default] $dbd_host = 'localhost',
  String[1,default] $dbd_addr = $dbd_host,
  String[0,default] $dbd_backup_host = '',
  Integer[0,default] $dbd_port = $slurm::config::accounting_storage_port,
  Enum['auth/none','auth/munge'] $auth_type = 'auth/none',
  String[0,default] $auth_info = '',
  String[0,default] $default_qos = '',
  Integer[0,default] $message_timeout = 10,
  String[1,default] $pid_file = '/var/run/slurmdbd.pid',
  String[1,default] $plugin_dir = '/usr/local/lib/slurm' ,
  String[0,default] $private_data = '',
  String[1,default] $slurm_user = $slurm::config::slurm_user,
  Integer[0,default] $tcp_timeout = 2,
  Enum['no','yes'] $track_wc_key = 'no',
  Enum['no','yes'] $track_slurmctld_down = 'no',
  Enum['accounting_storage/mysql'] $storage_type = 'accounting_storage/mysql',
  String[1,default] $storage_host = 'db_instance.example.org',
  String[0,default] $storage_backup_host = '',
  Integer[0,default] $storage_port = 1234,
  String[1,default] $storage_user = 'user',
  String[1,default] $storage_pass = 'CHANGEME__storage_pass',
  String[1,default] $storage_loc = 'accountingdb',
  String[1,default] $archive_dir = '/tmp',
  String[0,default] $archive_script = '',
  Enum['no','yes'] $archive_events = 'no',
  String[0,default] $purge_event_after = '',
  Enum['no','yes'] $archive_jobs = 'no',
  String[0,default] $purge_job_after = '',
  Enum['no','yes'] $archive_resvs = 'no',
  String[0,default] $purge_resv_after = '',
  Enum['no','yes'] $archive_steps = 'no',
  String[0,default] $purge_step_after = '',
  Enum['no','yes'] $archive_suspend = 'no',
  String[0,default] $purge_suspend_after = '',
  Enum['no','yes'] $archive_txn = 'no',
  String[0,default] $purge_txnafter = '',
  Enum['no','yes'] $archive_usage = 'no',
  String[0,default] $purge_usage_after = '',
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $debug_level = 'info',
  Array[Enum['DB_ARCHIVE','DB_ASSOC','DB_EVENT','DB_JOB','DB_QOS','DB_QUERY','DB_RESERVATION','DB_RESOURCE','DB_STEP','DB_USAGE','DB_WCKEY']] $debug_flags = [],
  String[0,default] $log_file = '',
  Enum['iso8601','iso8601_ms','rfc5424','rfc5424_ms','clock','short'] $log_time_format = 'iso8601_ms',
) {

  file{ "/etc/slurm/${file_name}":
    ensure  => file,
    content => template('slurm/slurmdbd.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0400',
    require => User['slurm'],
  }

  service{'slurmdbd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [
      Package['slurm-slurmdbd'],
      File[$slurm::config::required_files],
    ],
  }
}
