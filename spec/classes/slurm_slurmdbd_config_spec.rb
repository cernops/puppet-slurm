require 'spec_helper'

describe 'slurm::slurmdbd::config' do
  let(:facts) { default_facts }
  let :pre_condition do
    [
      "class { 'slurm': }",
    ]
  end
  let(:params) {{ }}

  it { should create_class('slurm::slurmdbd::config') }

  it { should contain_class('mysql::server') }

  it do
    should contain_mysql__db('slurmdbd').with({
      :user     => 'slurmdbd',
      :password => 'slurmdbd',
      :host     => 'localhost',
      :grant    => ['ALL'],
    })
  end

  it do
    should contain_file('slurmdbd.conf').with({
      :ensure => 'file',
      :path   => '/home/slurm/conf/slurmdbd.conf',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0600',
      :notify => 'Service[slurmdbd]',
    })
  end

  it do
    content = catalogue.resource('file', 'slurmdbd.conf').send(:parameters)[:content]
    config = content.split("\n").reject { |c| c =~ /(^#|^$)/ }
    config.should == [
      "ArchiveDir=/tmp",
      "ArchiveEvents=no",
      "ArchiveJobs=no",
      "ArchiveSteps=no",
      "ArchiveSuspend=no",
      "AuthType=auth/munge",
      "DbdHost=slurm",
      "DbdPort=6819",
      "DebugLevel=3",
      "LogFile=/var/log/slurm/slurmdbd.log",
      "MessageTimeout=10",
      "PidFile=/var/run/slurm/slurmdbd.pid",
      "PluginDir=/usr/lib64/slurm",
      "SlurmUser=slurm",
      "StorageHost=localhost",
      "StorageLoc=slurmdbd",
      "StoragePass=slurmdbd",
      "StoragePort=3306",
      "StorageType=accounting_storage/mysql",
      "StorageUser=slurmdbd",
      "TrackSlurmctldDown=no",
    ]
  end

  it do
    should contain_file('/etc/slurm/slurmdbd.conf').only_with({
      :ensure   => 'link',
      :path     => '/etc/slurm/slurmdbd.conf',
      :target   => '/home/slurm/conf/slurmdbd.conf',
    })
  end

  it do
    should contain_logrotate__rule('slurmdbd').with({
      :path          => '/var/log/slurm/slurmdbd.log',
      :compress      => 'true',
      :missingok     => 'true',
      :copytruncate  => 'false',
      :delaycompress => 'false',
      :ifempty       => 'false',
      :rotate        => '10',
      :sharedscripts => 'true',
      :size          => '10M',
      :create        => 'true',
      :create_mode   => '0640',
      :create_owner  => 'slurm',
      :create_group  => 'root',
      :postrotate    => '/etc/init.d/slurmdbd reconfig >/dev/null 2>&1',
    })
  end

  context 'when slurmdbd_conf_override defined' do
    let(:params) {{ :slurmdbd_conf_override => { 'PrivateData' => 'users' } }}

    it "should override values" do
      verify_contents(catalogue, 'slurmdbd.conf', ['PrivateData=users'])
    end
  end

  context 'when storage_pass => "foobar"' do
    let(:params) {{ :storage_pass => 'foobar' }}
    it "should override values" do
      verify_contents(catalogue, 'slurmdbd.conf', ['StoragePass=foobar'])
    end
  end

  context 'when manage_logrotate => false' do
    let(:params) {{ :manage_logrotate => false }}
    it { should_not contain_logrotate__rule('slurmdbd') }
  end

  context 'when manage_database => false' do
    let(:params) {{ :manage_database => false }}
    it { should_not contain_class('mysql::server') }
    it { should_not contain_mysql__db('slurmdbd') }
  end

  context 'when conf_dir => "/etc/slurm"' do
    let(:pre_condition) { "class { 'slurm': conf_dir => '/etc/slurm' }" }
    it { should_not contain_file('/etc/slurm/slurmdbd.conf') }
  end
end
