# Fact: threadcountpercore
#
# Purpose: Return the number of threads per core
#
# Rants: Nacho Barrientos <nacho.barrientos@cern.ch>
#
Facter.add('threadcountpercore') do
  confine :kernel => :linux

  setcode do
    sockets = Facter.value(:physicalprocessorcount).to_i
    vcpus = Facter.value(:processorcount).to_i
    corespercpu = Facter.value(:corecountpercpu)
    vcpus / (sockets * corespercpu)
  end
end
