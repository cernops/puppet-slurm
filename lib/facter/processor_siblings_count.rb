# Fact: processor_siblings_count
#
# Purpose: Return the number of siblings per physical processor
#
# Caveats: It assumes homogeneous physical CPUs
#

require 'facter/util/file_read'

default_siblings_count = 1
source = '/proc/cpuinfo'

Facter.add('processor_siblings_count') do
  confine :kernel => :linux

  if File.exists?(source)
    output = Facter::Util::FileRead.read(source)
    result = output[/^siblings.*(\d+)/, 1]

    setcode do
      if result.nil?
        default_siblings_count
      else
        result.to_i
      end
    end
  end
end
