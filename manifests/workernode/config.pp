class slurm::workernode::config {
  # We need to create folders/logfiles for slurm according to what we put in the slurm.conf file.
  # 
  # E.g. puppetize this, or if we build our own package, we could put it in the spec.
  # mkdir /var/spool/slurmd
  # chown slurm: /var/spool/slurmd
  # chmod 755 /var/spool/slurmd
  # touch /var/log/slurmd.log
  # chown slurm: /var/log/slurmd.log
}
