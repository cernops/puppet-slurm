# Fact: slurm_processor_siblings_count
#
# Purpose: Return the number of siblings per physical processor
#
# Caveats: It assumes homogeneous physical CPUs
#
require 'facter/util/slurm'

Facter.add(:slurm_processor_siblings_count) do
  confine :kernel => :linux

  setcode do
    value = nil
    output = Facter::Util::Slurm.read_procfs('/proc/cpuinfo')
    if ! output.nil?
      result = output[/^siblings.*(\d+)/, 1]
      if ! result.nil?
        value = result.to_i
      end
    end
    value
  end
end
