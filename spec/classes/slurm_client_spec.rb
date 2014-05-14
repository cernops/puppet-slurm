require 'spec_helper'

describe 'slurm::client' do
  let(:facts) { default_facts }
  let(:params) {{ }}
  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::client') }
  it { should contain_class('slurm') }

  it { should contain_anchor('slurm::client::start').that_comes_before('Class[slurm::user]') }
  it { should contain_class('slurm::user').that_comes_before('Class[slurm::munge]') }
  it { should contain_class('slurm::munge').that_comes_before('Class[slurm::install]') }
  it { should contain_anchor('slurm::client::end') }

  it do
    should contain_class('slurm::install').with({
      :ensure           => 'present',
      :package_require  => nil,
      :use_pam          => 'false',
      :with_devel       => 'false',
    }).that_comes_before('Class[slurm::config]')
  end

  it do
    should contain_class('slurm::config').with({
      :manage_slurm_conf  => 'false',
    }).that_comes_before('Class[slurm::service]')
  end

  it do
    should contain_class('slurm::service').with({
      :ensure => 'stopped',
      :enable => 'false',
    }).that_comes_before('Anchor[slurm::client::end]')
  end

  # Test validate_bool parameters
  [
    'with_devel',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('slurm::client') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end
end
