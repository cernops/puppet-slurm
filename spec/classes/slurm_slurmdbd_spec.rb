require 'spec_helper'

describe 'slurm::slurmdbd' do
  let(:facts) { default_facts }
  let(:params) {{ }}
  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::slurmdbd') }
  it { should contain_class('slurm') }

  it { should contain_anchor('slurm::slurmdbd::start').that_comes_before('Class[slurm::user]') }
  it { should contain_class('slurm::user').that_comes_before('Class[slurm::munge]') }
  it { should contain_class('slurm::munge').that_comes_before('Class[slurm::slurmdbd::install]') }
  it { should contain_class('slurm::config::common').that_comes_before('Class[slurm::slurmdbd::config]') }
  it { should contain_class('slurm::slurmdbd::config').that_comes_before('Class[slurm::slurmdbd::service]') }
  it { should contain_class('slurm::slurmdbd::service').that_comes_before('Anchor[slurm::slurmdbd::end]') }
  it { should contain_anchor('slurm::slurmdbd::end') }

  it do
    should contain_class('slurm::slurmdbd::install').with({
      :ensure           => 'present',
      :package_require  => nil,
    }).that_comes_before('Class[slurm::config::common]')
  end

  it do
    should contain_class('slurm::slurmdbd::config').with({
      :manage_database      => 'true',
      :use_remote_database  => 'false',
      :manage_logrotate     => 'true',
    }).that_comes_before('Class[slurm::slurmdbd::service]')
  end

  it do
    should contain_firewall('100 allow access to slurmdbd').with({
      :proto  => 'tcp',
      :dport  => '6819',
      :action => 'accept',
    })
  end

  context 'when manage_firewall => false' do
    let(:params) {{ :manage_firewall => false }}
    it { should_not contain_firewall('100 allow access to slurmdbd') }
  end

  # Test validate_bool parameters
  [
    'manage_database',
    'use_remote_database',
    'manage_firewall',
    'manage_logrotate',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('slurm::slurmdbd') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end

  # Test validate_hash parameters
  [
    'slurmdbd_conf_override',
  ].each do |p|
    context "when #{p} => 'foo'" do
      let(:params) {{ p => 'foo' }}
      it { expect { should create_class('slurm') }.to raise_error(Puppet::Error, /is not a Hash/) }
    end
  end
end
