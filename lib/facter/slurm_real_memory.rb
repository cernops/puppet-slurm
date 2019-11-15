# Fact: slurm_real_memory
#
# Purpose: Return the system memory rounded to nearest
#          hundredth.
#
require 'facter/util/slurm'

Facter.add(:slurm_real_memory) do
  confine kernel: :linux

  setcode do
    value = nil
    mem = Facter::Util::Slurm.get_fact(:memorysize_mb)
    unless mem.nil?
      value = mem.to_i / 100 * 100
    end
    value
  end
end
