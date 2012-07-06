class slurm::slurmdb::firewall {
   firewall {'100 allow access to slurmdbd listening port from the universe.':
          proto       => 'tcp',
          dport       => ["$slurm::params::slurmdbd_port"],
          action      => 'accept'
   }
}
