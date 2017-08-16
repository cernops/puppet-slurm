# slurm/dbnode/config.pp
#
# Creates the slurmdb configuration file and ensures that the slurmdbd service is running and restarted if the configuration file is modified.
#
# For details about the parameters, please refer to the SLURM documentation at https://slurm.schedmd.com/slurmdbd.conf.html
#
# version 20170816
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::config (
  String $file_name = 'slurmdbd.conf',
  String $dbd_host = 'localhost',
  String $dbd_addr = $dbd_host,
  Optional[String] $dbd_backup_host = undef,
  Integer[0] $dbd_port = $slurm::config::accounting_storage_port,
  Enum['auth/none','auth/munge'] $auth_type = 'auth/none',
  Optional[String] $auth_info = undef,
  Optional[String] $default_qos = undef,
  Integer[0] $message_timeout = 10,
  String $pid_file = '/var/run/slurmdbd.pid',
  String $plugin_dir = '/usr/local/lib/slurm' ,
  Optional[String] $private_data = undef,
  String $slurm_user = $slurm::config::slurm_user,
  Integer[0] $tcp_timeout = 2,
  Enum['no','yes'] $track_wc_key = 'no',
  Enum['no','yes'] $track_slurmctld_down = 'no',
  Enum['accounting_storage/mysql'] $storage_type = 'accounting_storage/mysql',
  String $storage_host = 'db_instance.example.org',
  Optional[String] $storage_backup_host = undef,
  Integer[0] $storage_port = 1234,
  String $storage_user = 'user',
  String $storage_pass = 'CHANGEME__storage_pass',
  String $storage_loc = 'accountingdb',
  String $archive_dir = '/tmp',
  Optional[String] $archive_script = undef,
  Enum['no','yes'] $archive_events = 'no',
  Optional[String] $purge_event_after = undef,
  Enum['no','yes'] $archive_jobs = 'no',
  Optional[String] $purge_job_after = undef,
  Enum['no','yes'] $archive_resvs = 'no',
  Optional[String] $purge_resv_after = undef,
  Enum['no','yes'] $archive_steps = 'no',
  Optional[String] $purge_step_after = undef,
  Enum['no','yes'] $archive_suspend = 'no',
  Optional[String] $purge_suspend_after = undef,
  Enum['no','yes'] $archive_txn = 'no',
  Optional[String] $purge_txnafter = undef,
  Enum['no','yes'] $archive_usage = 'no',
  Optional[String] $purge_usage_after = undef,
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $debug_level = 'info',
  Optional[Array[Enum['DB_ARCHIVE','DB_ASSOC','DB_EVENT','DB_JOB','DB_QOS','DB_QUERY','DB_RESERVATION','DB_RESOURCE','DB_STEP','DB_USAGE','DB_WCKEY']]] $debug_flags = undef,
  Optional[String] $log_file = undef,
  Enum['iso8601','iso8601_ms','rfc5424','rfc5424_ms','clock','short'] $log_time_format = 'iso8601_ms',
) {

  file{ delete(dirtree($log_file), $log_file) :
    ensure  => directory,
  }
  -> file{ 'slurmdbd log file':
    ensure => file,
    path   => $log_file,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }
  -> logrotate::file{ 'slurmdbd':
    log     => $log_file,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }

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

  if ($slurm::config::open_firewall) {
    firewall{ '203 open slurmdbd port':
      action => 'accept',
      dport  => $slurm::config::accounting_storage_port,
      proto  => 'tcp',
    }
  }
}
