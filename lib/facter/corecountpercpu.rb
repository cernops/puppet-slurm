# Fact: corecountpercpu
#
# Purpose: Return the number of cores per physical processor
#
# Caveats: It assumes homogeneous physical CPUs
#
# Rants: Nacho Barrientos <nacho.barrientos@cern.ch>
#

default_corecount = 1
source = '/proc/cpuinfo'

Facter.add('corecountpercpu') do
  confine :kernel => :linux

  if File.exists?(source)
    output = Facter::Util::FileRead.read(source)
    info = output.grep(/cpu cores/).first

    if info.nil?
      result = default_corecount
    else
      result = info[/(\d+)/].to_i
    end
  end

  setcode do
    result
  end
end
