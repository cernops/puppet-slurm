require 'spec_helper'

describe 'slurm::worker' do
  let(:facts) { default_facts }
  let(:params) {{ }}
  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::worker') }
  it { should contain_class('slurm') }

  it { should contain_anchor('slurm::worker::start').that_comes_before('Class[slurm::user]') }
  it { should contain_class('slurm::user').that_comes_before('Class[slurm::munge]') }
  it { should contain_class('slurm::munge').that_comes_before('Class[slurm::install]') }
  it { should contain_class('slurm::worker::config').that_comes_before('Class[slurm::service]') }
  it { should contain_anchor('slurm::worker::end') }

  it do
    should contain_class('slurm::install').with({
      :ensure           => 'present',
      :package_require  => nil,
      :use_pam          => 'false',
      :with_devel       => 'false',
    }).that_comes_before('Class[slurm::config::common]')
  end

  it do
    should contain_class('slurm::config::common').with({
      :slurm_user        => 'slurm',
      :slurm_user_group  => 'slurm',
      :log_dir           => '/var/log/slurm',
      :pid_dir           => '/var/run/slurm',
      :shared_state_dir  => '/var/lib/slurm',
    }).that_comes_before('Class[slurm::config]')
  end

  it do
    should contain_class('slurm::config').with({
      :manage_slurm_conf  => 'false',
    }).that_comes_before('Class[slurm::worker::config]')
  end

  it do
    should contain_class('slurm::service').with({
      :ensure => 'running',
      :enable => 'true',
    }).that_comes_before('Anchor[slurm::worker::end]')
  end

  it do
    should contain_firewall('100 allow access to slurmd').with({
      :proto  => 'tcp',
      :dport  => '6818',
      :action => 'accept',
    })
  end

  context 'when manage_firewall => false' do
    let(:params) {{ :manage_firewall => false }}
    it { should_not contain_firewall('100 allow access to slurmd') }
  end

  # Test validate_bool parameters
  [
    'manage_slurm_conf',
    'with_devel',
    'manage_firewall',
    'manage_logrotate',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('slurm::worker') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end
end
