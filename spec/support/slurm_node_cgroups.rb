shared_examples_for 'slurm::node::cgroups' do
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
end
