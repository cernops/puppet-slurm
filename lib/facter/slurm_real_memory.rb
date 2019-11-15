# Fact: slurm_real_memory
#
# Purpose: Return the system memory rounded to nearest
#          hundredth.
#
require 'facter/util/slurm'

Facter.add(:slurm_real_memory) do
  confine :kernel => :linux

  setcode do
    mem = Facter::Util::Slurm.get_fact(:memorysize_mb).to_i
    real_mem = mem / 100 * 100
  end
end
