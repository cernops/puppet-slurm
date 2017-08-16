Puppet::Type.newtype(:dirtree) do
  desc "Ensure the presence of a directory structure on the client"

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      raise Puppet::ParseError, 'The dirtree type does not support removal. Use the File type.'
    end
  end

  newparam(:path, :namevar => true) do
    desc 'The path of the directory'
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Directory tree paths must be fully qualified, not '#{value}'"
      end
    end
  end

  newparam(:parents) do
    desc 'Create parents recursively'
    newvalues true, false
    defaultto false
  end
end
