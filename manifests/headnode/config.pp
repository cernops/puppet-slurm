#
# slurm/headnode.pp
#
#

class slurm::headnode::config (
  $slurmctl_folder = '/var/spool/slurmctld',
){
  # We need to create folders/logfiles for slurm according to what we put in the slurm.conf file.
  #
  # E.g. puppetize this, or if we build our own package, we could put it in the spec.
  # mkdir /var/spool/slurmctld
  # chown slurm: /var/spool/slurmctld
  # chmod 755 /var/spool/slurmctld
  # touch /var/log/slurmctld.log
  # chown slurm: /var/log/slurmctld.log
  # touch /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
  # chown slurm: /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log

  file{ 'slurmctl folder':
    ensure => directory,
    path   => $slurmctl_folder,
    group  => 'slurm',
    mode   => '1664',
    owner  => 'slurm',
  }

}
