# SLURM fact util class
class Facter::Util::Slurm
  # Reads the contents of path in procfs
  #
  # @return [String]
  #
  # @api private
  def self.read_procfs(path)
    output = nil
    output = Facter::Util::Resolution.exec(['cat ', path].join) if File.exist?(path)
    return nil if output.nil?
    output.strip
  end

  def self.get_fact(fact)
    Facter.value(fact)
  end
end
