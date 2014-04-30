# Fact: real_memory
#
# Purpose: Return the system memory rounded to nearest
#          thousandth.
#
Facter.add('real_memory') do
  confine :kernel => :linux

  mem = Facter.value(:memorysize_mb).to_i

  setcode do
    mem / 1000 * 1000
  end
end
