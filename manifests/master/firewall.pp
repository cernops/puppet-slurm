class slurm::master::firewall {
   firewall {'100 allow access to slurmctld listening port from the universe.':
          proto       => 'tcp',
          dport       => ["$slurm::params::slurmctld_port"],
          action      => 'accept'
   }
}
