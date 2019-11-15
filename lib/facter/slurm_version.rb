# slurm_version.rb

Facter.add(:slurm_version) do
  confine kernel: :linux

  setcode do
    value = nil
    sinfo = Facter::Util::Resolution.which('sinfo')
    if sinfo
      output = Facter::Util::Resolution.exec("#{sinfo} -V 2>/dev/null")
      unless output.nil?
        value = output[%r{^slurm (.*)$}, 1]
      end
    end
    value
  end
end
