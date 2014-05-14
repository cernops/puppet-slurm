# == Class: slurm::slurmdb::config
#
class slurm::slurmdbd::config (
  $manage_database = true,
  $use_remote_database = false,
  $manage_logrotate = true,
  $slurmdbd_log_file = '/var/log/slurm/slurmdbd.log',
  $storage_host = 'localhost',
  $storage_loc = 'slurmdbd',
  $storage_pass = 'slurmdbd',
  $storage_port = '3306',
  $storage_type = 'accounting_storage/mysql',
  $storage_user = 'slurmdbd',
  $slurmdbd_conf_override = {},
) {

  include slurm

  $slurmdbd_conf_defaults = {
    'ArchiveDir' => '/tmp',
    'ArchiveEvents' => 'no',
    'ArchiveJobs' => 'no',
    'ArchiveSteps' => 'no',
    'ArchiveSuspend' => 'no',
    'AuthType' => 'auth/munge',
    'DbdHost' => $::hostname,
    'DbdPort' => $slurm::slurmdbd_port,
    'DebugLevel' => '3',
    'LogFile' => $slurmdbd_log_file,
    'MessageTimeout' => '10',
    'PidFile' => "${slurm::pid_dir}/slurmdbd.pid",
    'PluginDir' => '/usr/lib64/slurm',
    'SlurmUser' => $slurm::slurm_user,
    'StorageHost' => $storage_host,
    'StorageLoc' => $storage_loc,
    'StoragePass' => $storage_pass,
    'StoragePort' => $storage_port,
    'StorageType' => $storage_type,
    'StorageUser' => $storage_user,
    'TrackSlurmctldDown' => 'no',
  }

  $slurmdbd_conf_path = "${slurm::conf_dir}/slurmdbd.conf"
  $slurmdbd_conf      = merge($slurmdbd_conf_defaults, $slurmdbd_conf_override)

  if $manage_database {
    if $use_remote_database {
      #TODO: When puppetlabs-mysql released that supports dbname, use commented items
      #@@mysql::db { "slurmdbd_${::fqdn}":
      @@mysql::db { $storage_loc:
        user      => $storage_user,
        password  => $storage_pass,
        #dbname    => $slurm::storage_loc,
        host      => $::fqdn,
        grant     => ['ALL'],
        tag       => $::domain,
      }
    } else {
      include mysql::server

      mysql::db { $storage_loc:
        user      => $storage_user,
        password  => $storage_pass,
        host      => $storage_host,
        grant     => ['ALL'],
      }
    }
  }

  file { 'slurmdbd.conf':
    ensure  => 'file',
    path    => $slurmdbd_conf_path,
    owner   => $slurm::slurm_user,
    group   => $slurm::slurm_user_group,
    mode    => '0600',
    content => template('slurm/slurmdbd.conf.erb'),
    notify  => Service['slurmdbd'],
  }

  if $slurm::conf_dir != '/etc/slurm' {
    file { '/etc/slurm/slurmdbd.conf':
      ensure  => 'link',
      path    => '/etc/slurm/slurmdbd.conf',
      target  => $slurmdbd_conf_path,
    }
  }

  if $manage_logrotate {
    #Refer to: https://computing.llnl.gov/linux/slurm/slurm.conf.html#lbAJ
    logrotate::rule { 'slurmdbd':
      path          => $slurmdbd_log_file,
      compress      => true,
      missingok     => true,
      copytruncate  => false,
      delaycompress => false,
      ifempty       => false,
      rotate        => 10,
      sharedscripts => true,
      size          => '10M',
      create        => true,
      create_mode   => '0640',
      create_owner  => $slurm::slurm_user,
      create_group  => 'root',
      postrotate    => '/etc/init.d/slurmdbd reconfig >/dev/null 2>&1',
    }
  }

}
