shared_examples 'slurm::master::config' do
  let(:params) { context_params }

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

  it do
    should contain_file('StateSaveLocation').with({
      :ensure   => 'directory',
      :path     => '/var/lib/slurm/state',
      :owner    => 'slurm',
      :group    => 'slurm',
      :mode     => '0700',
      :require  => 'File[/var/lib/slurm]',
    })
  end

  it do
    should contain_file('JobCheckpointDir').with({
      :ensure   => 'directory',
      :path     => '/var/lib/slurm/checkpoint',
      :owner    => 'slurm',
      :group    => 'slurm',
      :mode     => '0700',
      :require  => 'File[/var/lib/slurm]',
    })
  end

  it do
    should contain_mount('StateSaveLocation').with({
      :ensure   => 'mounted',
      :name     => '/var/lib/slurm/state',
      :atboot   => 'true',
      :device   => nil,
      :fstype   => 'nfs',
      :options  => 'rw,sync,noexec,nolock,auto',
      :require  => 'File[StateSaveLocation]',
    })
  end

  it do
    should contain_logrotate__rule('slurmctld').with({
      :path          => '/var/log/slurm/slurmctld.log',
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
      :postrotate    => '/etc/init.d/slurm reconfig >/dev/null 2>&1',
    })
  end

  it do
    should contain_sysctl('net.core.somaxconn').with({
      :ensure => 'present',
      :value  => '1024',
    })
  end

  context 'when manage_logrotate => false' do
    let(:params) { context_params.merge({ :manage_logrotate => false }) }
    it { should_not contain_logrotate__rule('slurmctld') }
  end

  context 'when state_dir_nfs_device => "192.168.1.1:/slurm/state"' do
    let(:params) { context_params.merge({ :state_dir_nfs_device => "192.168.1.1:/slurm/state" }) }
    it { should contain_mount('StateSaveLocation').with_device('192.168.1.1:/slurm/state') }
  end

  context 'when state_dir_nfs_options => "foo,bar"' do
    let(:params) { context_params.merge({ :state_dir_nfs_options => "foo,bar" }) }
    it { should contain_mount('StateSaveLocation').with_options('foo,bar') }
  end

  context 'when manage_state_dir_nfs_mount => false' do
    let(:params) { context_params.merge({ :manage_state_dir_nfs_mount => false }) }
    it { should_not contain_mount('StateSaveLocation') }
  end
end
