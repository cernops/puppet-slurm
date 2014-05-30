require 'spec_helper'

describe 'slurm::controller' do
  let(:facts) { default_facts }
  let(:params) {{ }}
  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::controller') }
  it { should contain_class('slurm') }

  it { should contain_anchor('slurm::controller::start').that_comes_before('Class[slurm::user]') }
  it { should contain_class('slurm::user').that_comes_before('Class[slurm::munge]') }
  it { should contain_class('slurm::munge').that_comes_before('Class[slurm::install]') }
  it { should contain_class('slurm::config::common').that_comes_before('Class[slurm::config]') }
  it { should contain_anchor('slurm::controller::end') }

  it do
    should contain_class('slurm::install').with({
      :ensure                 => 'present',
      :package_require        => nil,
      :use_pam                => 'false',
      :with_devel             => 'false',
      :install_torque_wrapper => 'true',
      :install_tools          => 'true',
    }).that_comes_before('Class[slurm::config::common]')
  end

  it do
    should contain_class('slurm::config').with({
      :manage_slurm_conf  => 'true',
    }).that_comes_before('Class[slurm::controller::config]')
  end

  it do
    should contain_class('slurm::controller::config').with({
      :manage_state_dir_nfs_mount  => 'false',
      :state_dir_nfs_device        => nil,
      :state_dir_nfs_options       => 'rw,sync,noexec,nolock,auto',
      :manage_logrotate            => 'true',
    }).that_comes_before('Class[slurm::service]')
  end

  it do
    should contain_class('slurm::service').with({
      :ensure => 'running',
      :enable => 'true',
    }).that_comes_before('Anchor[slurm::controller::end]')
  end

  it do
    should contain_firewall('100 allow access to slurmctld').with({
      :proto  => 'tcp',
      :dport  => '6817',
      :action => 'accept',
    })
  end

  context 'when manage_firewall => false' do
    let(:params) {{ :manage_firewall => false }}
    it { should_not contain_firewall('100 allow access to slurmctld') }
  end

  context 'when both slurm::controller and slurm::slurmdbd' do
    let(:pre_condition) { "class { 'slurm::slurmdbd': }" }

    it { should contain_class('slurm::slurmdbd') }
  end

  # Test validate_bool parameters
  [
    'manage_slurm_conf',
    'manage_state_dir_nfs_mount',
    'with_devel',
    'install_torque_wrapper',
    'manage_firewall',
    'manage_logrotate',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('slurm::controller') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end
end
