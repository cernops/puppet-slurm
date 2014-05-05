shared_examples 'slurm::slurmdbd::config' do
  let(:params) { context_params }

  it do
    should contain_file('/etc/slurm/slurmdbd.conf').with({
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
      :notify => 'Service[slurmdbd]',
    })
  end

  it do
    content = catalogue.resource('file', '/etc/slurm/slurmdbd.conf').send(:parameters)[:content]
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
    let :params do
      context_params.merge({
        :slurmdbd_conf_override => {
          'PrivateData'   => 'users',
        }
      })
    end

    it "should override values" do
      verify_contents(catalogue, '/etc/slurm/slurmdbd.conf', [
        'PrivateData=users',
      ])
    end
  end

  context 'when storage_pass => "foobar"' do
    let(:params) { context_params.merge({ :storage_pass => 'foobar' }) }
    it "should override values" do
      verify_contents(catalogue, '/etc/slurm/slurmdbd.conf', ['StoragePass=foobar'])
    end
  end

  context 'when manage_logrotate => false' do
    let(:params) { context_params.merge({ :manage_logrotate => false }) }
    it { should_not contain_logrotate__rule('slurmdbd') }
  end
end
