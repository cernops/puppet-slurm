require 'spec_helper'

describe 'slurm' do
  let :default_facts do
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

  let(:facts) { default_facts }
  let(:params) {{ }}

  it { should create_class('slurm') }
  it { should contain_class('slurm::params') }

  context 'when worker only' do
    let :context_params do
      {
        :worker   => true,
        :master   => false,
        :slurmdbd => false,
      }
    end

    let(:facts) { default_facts }
    let(:params) { context_params }

    it { should contain_class('slurm::worker') }
    it { should_not contain_class('slurm::master') }
    it { should_not contain_class('slurm::slurmdb') }

    it { should contain_anchor('slurm::worker::start').that_comes_before('Class[slurm::user]') }
    it { should contain_class('slurm::user').that_comes_before('Class[slurm::munge]') }
    it { should contain_class('slurm::munge').that_comes_before('Class[slurm::worker::install]') }
    it { should contain_class('slurm::worker::install').that_comes_before('Class[slurm::worker::config]') }
    it { should contain_class('slurm::worker::config').that_comes_before('Class[slurm::worker::firewall]') }
    it { should contain_class('slurm::worker::firewall').that_comes_before('Class[slurm::worker::service]') }
    it { should contain_class('slurm::worker::service').that_comes_before('Anchor[slurm::worker::end]') }
    it { should contain_anchor('slurm::worker::end') }

    it_behaves_like 'slurm::user'
    it_behaves_like 'slurm::munge'
    it_behaves_like 'slurm::auks'
    it_behaves_like 'slurm::worker::install'
    it_behaves_like 'slurm::worker::config'
    it_behaves_like 'slurm_conf_common'
    it_behaves_like 'slurm_conf_partitions'
    it_behaves_like 'slurm::worker::firewall'
    it_behaves_like 'slurm::worker::service'
  end

  context 'when master only' do
    let :context_params do
      {
        :worker   => false,
        :master   => true,
        :slurmdbd => false,
      }
    end

    let(:facts) { default_facts }
    let(:params) { context_params }

    it { should contain_class('slurm::master') }
    it { should_not contain_class('slurm::worker') }
    it { should_not contain_class('slurm::slurmdb') }

    it { should contain_anchor('slurm::master::start').that_comes_before('Class[slurm::user]') }
    it { should contain_class('slurm::user').that_comes_before('Class[slurm::munge]') }
    it { should contain_class('slurm::munge').that_comes_before('Class[slurm::master::install]') }
    it { should contain_class('slurm::master::install').that_comes_before('Class[slurm::master::config]') }
    it { should contain_class('slurm::master::config').that_comes_before('Class[slurm::master::firewall]') }
    it { should contain_class('slurm::master::firewall').that_comes_before('Class[slurm::master::service]') }
    it { should contain_class('slurm::master::service').that_comes_before('Anchor[slurm::master::end]') }
    it { should contain_anchor('slurm::master::end') }

    it_behaves_like 'slurm::user'
    it_behaves_like 'slurm::munge'
    it_behaves_like 'slurm::auks'
    it_behaves_like 'slurm::master::install'
    it_behaves_like 'slurm::master::config'
    it_behaves_like 'slurm_conf_common'
    it_behaves_like 'slurm_conf_partitions'
    it_behaves_like 'slurm::master::firewall'
    it_behaves_like 'slurm::master::service'
  end

  context 'when slurmdbd only' do
    let :context_params do
      {
        :worker   => false,
        :master   => false,
        :slurmdbd => true,
      }
    end

    let(:facts) { default_facts }
    let(:params) { context_params }

    it { should contain_class('slurm::slurmdbd') }
    it { should_not contain_class('slurm::worker') }
    it { should_not contain_class('slurm::master') }

    it { should contain_anchor('slurm::slurmdbd::start').that_comes_before('Class[slurm::user]') }
    it { should contain_class('slurm::user').that_comes_before('Class[slurm::munge]') }
    it { should contain_class('slurm::munge').that_comes_before('Class[slurm::slurmdbd::install]') }
    it { should contain_class('slurm::slurmdbd::install').that_comes_before('Class[slurm::slurmdbd::config]') }
    it { should contain_class('slurm::slurmdbd::config').that_comes_before('Class[slurm::slurmdbd::firewall]') }
    it { should contain_class('slurm::slurmdbd::firewall').that_comes_before('Class[slurm::slurmdbd::service]') }
    it { should contain_class('slurm::slurmdbd::service').that_comes_before('Anchor[slurm::slurmdbd::end]') }
    it { should contain_anchor('slurm::slurmdbd::end') }

    it_behaves_like 'slurm::user'
    it_behaves_like 'slurm::munge'
    it_behaves_like 'slurm::slurmdbd::install'
    it_behaves_like 'slurm::slurmdbd::config'
    it_behaves_like 'slurm::slurmdbd::firewall'
    it_behaves_like 'slurm::slurmdbd::service'
  end

  # Test validate_bool parameters
  [
    'worker',
    'master',
    'slurmdbd',
    'manage_slurm_user',
    'manage_state_dir_nfs_mount',
    'use_auks',
    'use_pam',
    'manage_firewall',
    'manage_logrotate',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('slurm') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end

  # Test validate_array parameters
  [
    'partitionlist',
  ].each do |p|
    context "when #{p} => 'foo'" do
      let(:params) {{ p => 'foo' }}
      it { expect { should create_class('slurm') }.to raise_error(Puppet::Error, /is not an Array/) }
    end
  end

  # Test validate_hash parameters
  [
    'slurm_conf_override',
    'slurmdbd_conf_override',
  ].each do |p|
    context "when #{p} => 'foo'" do
      let(:params) {{ p => 'foo' }}
      it { expect { should create_class('slurm') }.to raise_error(Puppet::Error, /is not a Hash/) }
    end
  end
end
