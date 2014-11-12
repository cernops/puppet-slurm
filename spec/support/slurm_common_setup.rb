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
      'CONFDIR="/etc/slurm"',
      'SLURMCTLD_OPTIONS="-f /etc/slurm/slurm.conf"',
      'SLURMD_OPTIONS="-f /etc/slurm/slurm.conf -M"',
      'export SLURM_CONF="/etc/slurm/slurm.conf"',
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
      'export SLURM_CONF="/etc/slurm/slurm.conf"',
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
      'setenv SLURM_CONF="/etc/slurm/slurm.conf"',
    ])
  end

  it do
    should contain_file('slurm CONFDIR').with({
      :ensure => 'directory',
      :path   => '/etc/slurm',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
    })
  end
end
