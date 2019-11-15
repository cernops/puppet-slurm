# Private class
class slurm::slurmdbd::config {

  if $slurm::manage_database {
    if $slurm::use_remote_database {
      @@mysql::db { "slurmdbd_${::fqdn}":
        user     => $slurm::slurmdbd_storage_user,
        password => $slurm::slurmdbd_storage_pass,
        dbname   => $slurm::slurmdbd_storage_loc,
        host     => $::fqdn,
        grant    => ['ALL'],
        tag      => $::domain,
      }
    } else {
      include mysql::server

      mysql::db { $slurm::slurmdbd_storage_loc:
        user     => $slurm::slurmdbd_storage_user,
        password => $slurm::slurmdbd_storage_pass,
        host     => $slurm::slurmdbd_storage_host,
        grant    => ['ALL'],
      }
    }
  }

  file { 'slurmdbd.conf':
    ensure  => 'file',
    path    => $slurm::slurmdbd_conf_path,
    owner   => $slurm::slurm_user,
    group   => $slurm::slurm_user_group,
    mode    => '0600',
    content => template('slurm/slurmdbd/slurmdbd.conf.erb'),
    notify  => Service['slurmdbd'],
  }
}
