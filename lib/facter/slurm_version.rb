# slurm_version.rb

Facter.add(:slurm_version) do
  setcode do
    if sinfo = Facter::Util::Resolution.which("sinfo")
      if sinfo_v = Facter::Util::Resolution.exec("sinfo -V 2>/dev/null").match(/^slurm (.*)$/)
        result = sinfo_v[1]
      end
    end
  end
end
