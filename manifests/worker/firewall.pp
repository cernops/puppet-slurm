class slurm::worker::firewall {
   firewall {'100 allow access to slurmd listening port from the universe.':
          proto       => 'tcp',
          dport       => ["$slurm::params::slurmd_port"],
          action      => 'accept'
   }
}
