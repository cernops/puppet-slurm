shared_examples_for "slurm::common::setup" do

  it do
    should contain_file('/etc/sysconfig/slurm').with({
      :ensure  => 'file',
      :path    => '/etc/sysconfig/slurm',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/sysconfig/slurm', [
      'ulimit -l unlimited',
      'ulimit -n 8192',
      'CONFDIR="/home/slurm/conf"',
      'SLURMCTLD_OPTIONS="-f /home/slurm/conf/slurm.conf"',
      'SLURMD_OPTIONS="-f /home/slurm/conf/slurm.conf -M"',
      'export SLURM_CONF="/home/slurm/conf/slurm.conf"',
    ])
  end

  it do
    should contain_file('/etc/profile.d/slurm.sh').with({
      :ensure  => 'file',
      :path    => '/etc/profile.d/slurm.sh',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/profile.d/slurm.sh', [
      'export SLURM_CONF="/home/slurm/conf/slurm.conf"',
    ])
  end

  it do
    should contain_file('/etc/profile.d/slurm.csh').with({
      :ensure  => 'file',
      :path    => '/etc/profile.d/slurm.csh',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/profile.d/slurm.csh', [
      'setenv SLURM_CONF="/home/slurm/conf/slurm.conf"',
    ])
  end

  it do
    should contain_file('/etc/slurm').with({
      :ensure => 'link',
      :target => '/home/slurm/conf',
      :force  => 'true',
      :before => 'File[slurm CONFDIR]',
    })
  end

  it do
    should contain_file('slurm CONFDIR').with({
      :ensure => 'directory',
      :path   => '/home/slurm/conf',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
    })
  end

  context 'when conf_dir => "/etc/slurm"' do
    let(:params) {  default_params.merge({ :conf_dir => '/etc/slurm' }) }
    it { should_not contain_file('/etc/slurm') }
  end

  context 'when manage_slurm_conf => false' do
    let(:params) { default_params.merge({ :manage_slurm_conf => false }) }
    it { should_not contain_file('slurm CONFDIR') }
  end
end
