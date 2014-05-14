# == Class: slurm::slurmdbd
#
class slurm::slurmdbd (
  $manage_database = true,
  $use_remote_database = false,
  $manage_firewall = true,
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

  validate_bool($manage_database)
  validate_bool($use_remote_database)
  validate_bool($manage_firewall)
  validate_bool($manage_logrotate)
  validate_hash($slurmdbd_conf_override)

  anchor { 'slurm::slurmdbd::start': }
  anchor { 'slurm::slurmdbd::end': }

  include slurm
  include slurm::user
  include slurm::munge
  include slurm::config::common
  include slurm::slurmdbd::service

  class { 'slurm::slurmdbd::install':
    ensure          => $slurm::slurm_package_ensure,
    package_require => $slurm::package_require,
  }

  class { 'slurm::slurmdbd::config':
    manage_database         => $manage_database,
    use_remote_database     => $use_remote_database,
    manage_logrotate        => $manage_logrotate,
    slurmdbd_log_file       => $slurmdbd_log_file,
    storage_host            => $storage_host,
    storage_loc             => $storage_loc,
    storage_pass            => $storage_pass,
    storage_port            => $storage_port,
    storage_type            => $storage_type,
    storage_user            => $storage_user,
    slurmdbd_conf_override  => $slurmdbd_conf_override,
  }

  if $manage_firewall {
    firewall {'100 allow access to slurmdbd':
      proto   => 'tcp',
      dport   => $slurm::slurmdbd_port,
      action  => 'accept'
    }
  }

  Anchor['slurm::slurmdbd::start']->
  Class['slurm::user']->
  Class['slurm::munge']->
  Class['slurm::slurmdbd::install']->
  Class['slurm::config::common']->
  Class['slurm::slurmdbd::config']->
  Class['slurm::slurmdbd::service']->
  Anchor['slurm::slurmdbd::end']

}
