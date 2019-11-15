# Fact: slurm_core_count_per_cpu
#
# Purpose: Return the number of cores per physical processor
#
# Caveats: It assumes homogeneous physical CPUs
#
# Rants: Nacho Barrientos <nacho.barrientos@cern.ch>
#

require 'facter/util/slurm'

Facter.add(:slurm_core_count_per_cpu) do
  confine :kernel => :linux

  setcode do
    value = nil
    output = Facter::Util::Slurm.read_procfs('/proc/cpuinfo')
    if ! output.nil?
      result = output[/^cpu cores.*(\d+)/, 1]
      if ! result.nil?
        value = result.to_i
      end
    end
    value
  end
end
