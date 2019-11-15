require 'lib/module_spec_helper'

dir = File.expand_path(File.dirname(__FILE__))

Dir["#{dir}/shared_examples/*.rb"].sort.each { |f| require f }

def cpuinfo_fixtures(filename)
  fixtures('cpuinfo', filename)
end

def cpuinfo_fixture_read(filename)
  File.read(cpuinfo_fixtures(filename))
end

def cpuinfo_fixture_readlines(filename)
  cpuinfo_fixture_read(filename).split(%r{\n})
end

def meminfo_fixtures(filename)
  fixtures('meminfo', filename)
end

def meminfo_fixture_read(filename)
  File.read(meminfo_fixtures(filename))
end

def meminfo_fixture_readlines(filename)
  meminfo_fixture_read(filename).split(%r{\n})
end

class String
  def camel_case
    return self if self !~ %r{_} && self =~ %r{[A-Z]+.*}
    split('_').map { |e| e.capitalize }.join
  end
end
