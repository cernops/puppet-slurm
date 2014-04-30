require 'spec_helper'

describe 'slurm' do
  let :facts do
    {
      :osfamily => 'RedHat',
      :concat_basedir => '/tmp',
      :fqdn => 'slurm.example.com',
      :hostname => 'slurm',
      :physicalprocessorcount => '2',
      :corecountpercpu => '4',
      :threadcountpercore => '1',
      :real_memory => '32000',
    }
  end

  let :default_params do
    {
      :worker => true,
      :master => false,
      :slurmdb => false,
      :munge_package_ensure => 'present',
      :slurm_package_ensure => 'present',
      :auks_package_ensure => 'present',
    }
  end

  let(:params) { default_params }

  it { should create_class('slurm') }
  it { should contain_class('slurm::params') }

  it { should contain_anchor('slurm::start').that_comes_before('Class[slurm::install]') }
  it { should contain_class('slurm::install').that_comes_before('Class[slurm::config]') }
  it { should contain_class('slurm::config').that_comes_before('Class[slurm::firewall]') }
  it { should contain_class('slurm::firewall').that_comes_before('Class[slurm::service]') }
  it { should contain_class('slurm::service').that_comes_before('Anchor[slurm::end]') }
  it { should contain_anchor('slurm::end') }

  it { should contain_class('slurm::munge').that_comes_before('Class[slurm::install]') }

  it { should contain_class('slurm::config::worker') }
  it { should contain_class('slurm::config').that_comes_before('Class[slurm::config::worker]') }
  it { should_not contain_class('slurm::config::master') }

  context 'when master only' do
    let(:params) { default_params.merge({ :worker => false, :master => true }) }

    it { should contain_class('slurm::munge').that_comes_before('Class[slurm::install]') }

    it { should contain_class('slurm::config::master') }
    it { should contain_class('slurm::config').that_comes_before('Class[slurm::config::master]') }
    it { should_not contain_class('slurm::config::worker') }
  end

  it_behaves_like 'slurm::munge'
  it_behaves_like 'slurm::install'
  it_behaves_like 'slurm::config'
  it_behaves_like 'slurm::firewall'
  it_behaves_like 'slurm::service'
end
