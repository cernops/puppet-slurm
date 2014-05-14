require 'spec_helper'

describe 'slurm::master' do
  let(:facts) { default_facts }
  let(:params) {{ }}
  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::master') }
  it { should contain_class('slurm') }

  it { should contain_anchor('slurm::master::start').that_comes_before('Class[slurm::user]') }
  it { should contain_class('slurm::user').that_comes_before('Class[slurm::munge]') }
  it { should contain_class('slurm::munge').that_comes_before('Class[slurm::install]') }
  it { should contain_class('slurm::master::config').that_comes_before('Class[slurm::service]') }
  it { should contain_anchor('slurm::master::end') }

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
      :manage_slurm_conf  => 'true',
    }).that_comes_before('Class[slurm::master::config]')
  end

  it do
    should contain_class('slurm::service').with({
      :ensure => 'running',
      :enable => 'true',
    }).that_comes_before('Anchor[slurm::master::end]')
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

#  it_behaves_like 'slurm::auks'
#  it_behaves_like 'slurm::master::install'
#  it_behaves_like 'slurm::config'
#  it_behaves_like 'slurm::master::config'
#  it_behaves_like 'slurm::master::firewall'
#  it_behaves_like 'slurm::master::service'

  # Test validate_bool parameters
  [
    'manage_slurm_conf',
    'manage_state_dir_nfs_mount',
    'with_devel',
    'manage_firewall',
    'manage_logrotate',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('slurm::master') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end
end
