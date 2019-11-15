# Fact: slurm_thread_count_per_core
#
# Purpose: Return the number of threads per core
#
# Rants: Nacho Barrientos <nacho.barrientos@cern.ch>
#
require 'facter/util/slurm'

Facter.add(:slurm_thread_count_per_core) do
  confine kernel: :linux

  setcode do
    value = nil
    sockets = Facter::Util::Slurm.get_fact(:physicalprocessorcount)
    vcpus = Facter::Util::Slurm.get_fact(:processorcount)
    corespercpu = Facter::Util::Slurm.get_fact(:corecountpercpu)
    if !sockets.nil? && !vcpus.nil? && !corespercpu.nil?
      value = vcpus.to_i / (sockets.to_i * corespercpu.to_i)
    end
    value
  end
end
