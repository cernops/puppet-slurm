# @api private
class slurm::slurmdbd::db {
  if $slurm::manage_database {
    if $slurm::export_database {
      @@mysql::db { "slurmdbd_${::fqdn}":
        user     => $slurm::slurmdbd_storage_user,
        password => $slurm::slurmdbd_storage_pass,
        dbname   => $slurm::slurmdbd_storage_loc,
        host     => $::fqdn,
        grant    => ['ALL'],
        tag      => $::domain,
      }
    } else {
      mysql::db { $slurm::slurmdbd_storage_loc:
        user     => $slurm::slurmdbd_storage_user,
        password => $slurm::slurmdbd_storage_pass,
        host     => $slurm::slurmdbd_storage_host,
        grant    => ['ALL'],
      }
    }
  }
}
