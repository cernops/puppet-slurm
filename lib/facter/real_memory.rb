# Fact: real_memory
#
# Purpose: Return the system memory rounded to nearest
#          hundredth.
#
Facter.add('real_memory') do
  confine :kernel => :linux

  mem = Facter.value(:memorysize_mb).to_i
  real_mem = mem / 100 * 100

  setcode do
    real_mem
  end
end
