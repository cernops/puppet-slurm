Puppet::Type.type(:dirtree).provide(:ruby) do
  desc 'Ruby provider for the dirtree type'

  def exists?
    File.directory? resource[:path]
  end

  def create
    if resource[:parents]
      FileUtils.mkdir_p resource[:path]
    else
      FileUtils.mkdir resource[:path]
    end
  end

  def destroy
    true
  end
end
