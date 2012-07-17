# Fact: corecountpercpu
#
# Purpose: Return the number of cores per physical processor
#
# Caveats: It assumes homogeneous physical CPUs
#
# Rants: Nacho Barrientos <nacho.barrientos@cern.ch>
#

default_corecount = 1

Facter.add('corecountpercpu') do
  confine :kernel => :linux

  setcode do
    source = '/proc/cpuinfo'

    if File.exists?(source)
        info = Facter::Util::Resolution.exec("grep 'cpu cores' #{source}")
        if info.nil?
            default_corecount
        else
            info.scan(/(\d+)/).uniq.first.first.to_i
        end
    end
  end
end
