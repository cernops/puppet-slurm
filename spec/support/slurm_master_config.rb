shared_examples 'slurm::master::config' do
  let(:params) { context_params }

  it { should have_group_resource_count(1) }
  it { should have_user_resource_count(1) }

  it do
    should contain_group('slurm').with({
      :ensure => 'present',
      :name   => 'slurm',
      :gid    => nil,
    })
  end

  it do
    should contain_user('slurm').with({
      :ensure => 'present',
      :name   => 'slurm',
      :uid    => nil,
      :gid    => 'slurm',
      :shell  => '/bin/false',
      :home   => '/home/slurm',
      :comment  => 'SLURM User',
    })
  end

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
    should contain_file('/var/spool/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/lib/slurm/state').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/lib/slurm/checkpoint').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it do
    should contain_mount('/var/lib/slurm/state').with({
      :ensure   => 'mounted',
      :atboot   => 'true',
      :device   => nil,
      :fstype   => 'nfs',
      :options  => 'rw,sync,noexec,nolock,auto',
      :require  => 'File[/var/lib/slurm/state]',
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

  context 'when manage_slurm_group => false' do
    let(:params) { context_params.merge({ :manage_slurm_group => false }) }
    it { should_not contain_group('slurm') }
  end

  context 'when manage_slurm_user => false' do
    let(:params) { context_params.merge({ :manage_slurm_user => false }) }
    it { should_not contain_user('slurm') }
  end

  context 'when slurm_group_gid => 400' do
    let(:params) { context_params.merge({ :slurm_group_gid => 400 }) }
    it { should contain_group('slurm').with_gid('400') }
  end

  context 'when slurm_user_uid => 400' do
    let(:params) { context_params.merge({ :slurm_user_uid => 400 }) }
    it { should contain_user('slurm').with_uid('400') }
  end

  context 'when manage_logrotate => false' do
    let(:params) { context_params.merge({ :manage_logrotate => false }) }
    it { should_not contain_logrotate__rule('slurmctld') }
  end

  context 'when state_dir_nfs_device => "192.168.1.1:/slurm/state"' do
    let(:params) { context_params.merge({ :state_dir_nfs_device => "192.168.1.1:/slurm/state" }) }
    it { should contain_mount('/var/lib/slurm/state').with_device('192.168.1.1:/slurm/state') }
  end

  context 'when state_dir_nfs_options => "foo,bar"' do
    let(:params) { context_params.merge({ :state_dir_nfs_options => "foo,bar" }) }
    it { should contain_mount('/var/lib/slurm/state').with_options('foo,bar') }
  end

  context 'when manage_state_dir_nfs_mount => false' do
    let(:params) { context_params.merge({ :manage_state_dir_nfs_mount => false }) }
    it { should_not contain_mount('/var/lib/slurm/state') }
  end
end
