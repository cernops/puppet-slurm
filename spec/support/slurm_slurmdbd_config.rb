shared_examples_for 'slurm::slurmdbd::config' do
  it do
    should contain_file('/var/log/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/run/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/lib/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

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
      :path   => '/etc/slurm/slurmdbd.conf',
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
      "ArchiveResvs=no",
      "ArchiveSteps=no",
      "ArchiveSuspend=no",
      "AuthType=auth/munge",
      "DbdHost=#{facts[:hostname]}",
      "DbdPort=6819",
      "DebugLevel=info",
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
    let(:params) { default_params.merge({
      :slurmdbd_conf_override => { 'PrivateData' => 'users' } })
    }

    it "should override values" do
      verify_contents(catalogue, 'slurmdbd.conf', ['PrivateData=users'])
    end
  end

  context 'when slurmdbd_storage_pass => "foobar"' do
    let(:params) { default_params.merge({ :slurmdbd_storage_pass => 'foobar' }) }
    it "should override values" do
      verify_contents(catalogue, 'slurmdbd.conf', ['StoragePass=foobar'])
    end
  end

  context 'when manage_logrotate => false' do
    let(:params) { default_params.merge({ :manage_logrotate => false }) }
    it { should_not contain_logrotate__rule('slurmdbd') }
  end

  context 'when use_remote_database => true' do
    let(:params) { default_params.merge({ :use_remote_database => true }) }
    it { should_not contain_class('mysql::server') }
    it { should_not contain_mysql__db('slurmdbd') }
  end

  context 'when manage_database => false' do
    let(:params) { default_params.merge({ :manage_database => false }) }
    it { should_not contain_class('mysql::server') }
    it { should_not contain_mysql__db('slurmdbd') }
  end
end
