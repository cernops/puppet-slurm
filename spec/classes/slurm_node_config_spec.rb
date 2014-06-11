require 'spec_helper'

describe 'slurm::node::config' do
  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::node::config') }
  it { should contain_class('slurm') }

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
      :create_owner  => 'slurm',
      :create_group  => 'root',
      :postrotate    => '/etc/init.d/slurm reconfig >/dev/null 2>&1',
    })
  end

  context 'when manage_logrotate => false' do
    let(:params) {{ :manage_logrotate => false }}
    it { should_not contain_logrotate__rule('slurmd') }
  end
end
