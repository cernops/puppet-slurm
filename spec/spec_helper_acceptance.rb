require 'beaker-rspec'

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/acceptance/support/*.rb"].sort.each {|f| require f}

puppet_package_version = ENV['PUPPET_BEAKER_package_version'] || '3.5.1-1'

hosts.each do |host|
  # Start dnsmasq
  # Currently unused but left in hopes docker multinode
  # beaker tests will one day be possible
  if host['hypervisor'] =~ /docker/
    on host, 'service dnsmasq start', { :acceptable_exit_codes => [0,1] }
  end

  #install_puppet
  if host['platform'] =~ /el-(5|6)/
    relver = $1
    on host, "rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-#{relver}.noarch.rpm", { :acceptable_exit_codes => [0,1] }
    on host, "yum install -y puppet-#{puppet_package_version}.el6", { :acceptable_exit_codes => [0,1] }
  end
end

on master, "yum install -y puppet-server-#{puppet_package_version}.el6"

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  c.add_setting :slurm_yumrepo_baseurl
  c.slurm_yumrepo_baseurl = ENV['SLURM_BEAKER_yumrepo_baseurl']

  c.add_setting :slurm_package_version
  c.slurm_package_version = ENV['SLURM_BEAKER_package_version'] || '14.03.3-2.el6'

  # Configure all nodes in nodeset
  c.before :suite do
    RSpec.configuration.slurm_yumrepo_baseurl.should_not be_nil
    RSpec.configuration.slurm_package_version.should_not be_nil

    hosts.each do |host|
      # Only modify /etc/hosts if not running under docker
      unless host['hypervisor'] =~ /docker/
        host.exec(Beaker::Command.new("echo '#{master['ip']}\tpuppet.local' >> /etc/hosts"))
      end
    end

    # Install module and dependencies
    hosts.each do |host|
      copy_root_module_to(host, :module_name => 'slurm')
      copy_root_module_to(host, :source => File.join(proj_root, 'tests/site_slurm'), :module_name => 'site_slurm')
    end
    on hosts, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
    on hosts, puppet('module', 'install', 'puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
    on hosts, puppet('module', 'install', 'puppetlabs-firewall'), { :acceptable_exit_codes => [0,1] }
    on hosts, puppet('module', 'install', 'puppetlabs-mysql'), { :acceptable_exit_codes => [0,1] }
    on hosts, puppet('module', 'install', 'domcleal-augeasproviders'), { :acceptable_exit_codes => [0,1] }
    on hosts, puppet('module', 'install', 'rodjek-logrotate'), { :acceptable_exit_codes => [0,1] }
    on hosts, puppet('module', 'install', 'stahnma-epel'), { :acceptable_exit_codes => [0,1] }
    on hosts, puppet('module', 'install', 'puppetlabs-puppetdb'), { :acceptable_exit_codes => [0,1] }
    on hosts, puppet('module', 'install', 'saz-limits'), { :acceptable_exit_codes => [0,1] }
    on hosts, puppet('module', 'install', 'treydock-munge'), { :acceptable_exit_codes => [0,1] }

    puppet_pp = <<-EOF
    ini_setting { 'puppet.conf/main/server':
      ensure  => 'present',
      section => 'main',
      path    => '/etc/puppet/puppet.conf',
      setting => 'server',
      value   => 'puppet.local',
    }
    EOF

    puppet_master_pp = <<-EOF
    ini_setting { 'puppet.conf/master/certname':
      ensure  => 'present',
      section => 'master',
      path    => '/etc/puppet/puppet.conf',
      setting => 'certname',
      value   => 'puppet.local',
    }
    ini_setting { 'puppet.conf/master/autosign':
      ensure  => 'present',
      section => 'master',
      path    => '/etc/puppet/puppet.conf',
      setting => 'autosign',
      value   => true,
    }
    EOF

    hosts.each do |host|
      apply_manifest_on(host, puppet_pp, :catch_failures => true)
    end

    apply_manifest_on(master, puppet_master_pp, :catch_failures => true)
    apply_manifest_on(master, "service { 'puppetmaster': ensure => running }", :catch_failures => true)

    hosts.each do |host|
      on host, puppet('agent -t'), :acceptable_exit_codes => [0,1,2]
    end

    puppetdb_pp =<<-EOF
    class { 'puppetdb': ssl_listen_address => '0.0.0.0', listen_address => '0.0.0.0' } ->
    class { 'puppetdb::master::config': puppetdb_server => 'puppet.local' }
    EOF

    apply_manifest_on(master, puppetdb_pp, :catch_failures => true)

    puppetdb_conf_pp =<<-EOF
    package {'puppetdb-terminus':
      ensure => installed,
    }
    Ini_setting {
      ensure  => 'present',
      section => 'main',
    }
    ini_setting { 'puppet.conf/main/storeconfigs':
      setting => 'storeconfigs',
      value   => true,
      path    => '/etc/puppet/puppet.conf',
    }
    ini_setting { 'puppet.conf/main/storeconfigs_backend':
      setting => 'storeconfigs_backend',
      value   => 'puppetdb',
      path    => '/etc/puppet/puppet.conf',
    }
    ini_setting { 'puppetdbserver':
      setting => 'server',
      value   => 'puppet.local',
      path    => '/etc/puppet/puppetdb.conf',
    }
    ini_setting { 'puppetdbport':
      setting => 'port',
      value   => '8081',
      path    => '/etc/puppet/puppetdb.conf',
    }
    ini_setting { 'soft_write_failure':
      setting => 'soft_write_failure',
      value   => 'false',
      path    => '/etc/puppet/puppetdb.conf',
    }
    EOF

    hosts.each do |host|
      apply_manifest_on(host, puppetdb_conf_pp, :catch_failures => true)
    end
  end
end
