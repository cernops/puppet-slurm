class slurm::config {
  # Before installing, ensure that there is a Slurm user on both the head and all worker nodes with the same UID/GID!
  # 
  # I.e. puppetize something like this:
  # export SLURMUSER=992
  # groupadd -g $SLURMUSER slurm
  # useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm
}
