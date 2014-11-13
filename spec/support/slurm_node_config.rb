shared_examples_for 'slurm::node::config' do
  it do
    should contain_file('/etc/slurm/cgroup').with({
      :ensure => 'directory',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
      :before => 'File[/etc/slurm/cgroup/release_common]'
    })
  end

  it do
    should contain_file('/etc/slurm/cgroup/release_common').with({
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
      :source => 'file:///etc/slurm/cgroup.release_common.example',
      :before => 'File[/etc/slurm/cgroup/release_blkio]'
    })
  end

  it do
    should contain_file('/etc/slurm/cgroup/release_blkio').with({
      :ensure => 'link',
      :target => 'release_common',
      :before => 'File[/etc/slurm/cgroup/release_cpuacct]'
    })
  end

  it do
    should contain_file('/etc/slurm/cgroup/release_blkio').with({
      :ensure => 'link',
      :target => 'release_common',
      :before => 'File[/etc/slurm/cgroup/release_cpuacct]'
    })
  end

  it do
    should contain_file('/etc/slurm/cgroup/release_cpuacct').with({
      :ensure => 'link',
      :target => 'release_common',
      :before => 'File[/etc/slurm/cgroup/release_cpuset]'
    })
  end

  it do
    should contain_file('/etc/slurm/cgroup/release_cpuset').with({
      :ensure => 'link',
      :target => 'release_common',
      :before => 'File[/etc/slurm/cgroup/release_freezer]'
    })
  end

  it do
    should contain_file('/etc/slurm/cgroup/release_freezer').with({
      :ensure => 'link',
      :target => 'release_common',
      :before => 'File[/etc/slurm/cgroup/release_memory]'
    })
  end

  it do
    should contain_file('/etc/slurm/cgroup/release_memory').with({
      :ensure => 'link',
      :target => 'release_common',
      :before => 'File[/etc/slurm/cgroup/release_devices]'
    })
  end

  it do
    should contain_file('/etc/slurm/cgroup/release_devices').with({
      :ensure => 'link',
      :target => 'release_common',
    })
  end

  context 'when manage_cgroup_release_agents => false' do
    let(:params) { default_params.merge({ :manage_cgroup_release_agents => false }) }
    it { should_not contain_file('/etc/slurm/cgroup') }
    it { should_not contain_file('/etc/slurm/cgroup/release_common') }
    it { should_not contain_file('/etc/slurm/cgroup/release_blkio') }
    it { should_not contain_file('/etc/slurm/cgroup/release_cpuacct') }
    it { should_not contain_file('/etc/slurm/cgroup/release_cpuset') }
    it { should_not contain_file('/etc/slurm/cgroup/release_freezer') }
    it { should_not contain_file('/etc/slurm/cgroup/release_memory') }
    it { should_not contain_file('/etc/slurm/cgroup/release_devices') }
  end

  it do
    should contain_file('/var/log/slurm').with({
      :ensure => 'directory',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/run/slurm').with({
      :ensure => 'directory',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/lib/slurm').with({
      :ensure => 'directory',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('SlurmdSpoolDir').with({
      :ensure => 'directory',
      :path   => '/var/spool/slurmd',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
    })
  end

  it do
    should contain_limits__limits('unlimited_memlock').with({
      :ensure      => 'present',
      :user        => '*',
      :limit_type  => 'memlock',
      :hard        => 'unlimited',
      :soft        => 'unlimited',
    })
  end

  it do
    should contain_logrotate__rule('slurmd').with({
      :path          => '/var/log/slurm/slurmd.log',
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
      :create_owner  => 'root',
      :create_group  => 'root',
      :postrotate    => '/etc/init.d/slurm reconfig >/dev/null 2>&1',
    })
  end

  context 'when manage_logrotate => false' do
    let(:params) { default_params.merge({ :manage_logrotate => false }) }
    it { should_not contain_logrotate__rule('slurmd') }
  end
end
