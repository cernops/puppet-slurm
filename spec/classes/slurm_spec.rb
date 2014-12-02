require 'spec_helper'

describe 'slurm' do
  let(:facts) { default_facts }
  let(:params) {{ }}

  it { should create_class('slurm') }
  it { should contain_class('slurm::params') }

  context 'default' do
    let(:default_params) {{ }}
    let(:params) { default_params }

    it { should contain_anchor('slurm::start').that_comes_before('Class[slurm::node]') }
    it { should contain_class('slurm::node').that_comes_before('Anchor[slurm::end]') }
    it { should contain_anchor('slurm::end') }

    it { should_not contain_class('slurm::controller') }
    it { should_not contain_class('slurm::slurmdbd') }
    it { should_not contain_class('slurm::client') }

    it_behaves_like 'slurm::node'
  end

  context 'controller' do
    let(:default_params) {{ :controller => true, :node => false }}
    let(:params) { default_params }

    it { should contain_anchor('slurm::start').that_comes_before('Class[slurm::controller]') }
    it { should contain_class('slurm::controller').that_comes_before('Anchor[slurm::end]') }
    it { should contain_anchor('slurm::end') }

    it { should_not contain_class('slurm::node') }
    it { should_not contain_class('slurm::slurmdbd') }
    it { should_not contain_class('slurm::client') }

    it_behaves_like 'slurm::controller'
  end

  context 'client' do
    let(:default_params) {{ :client => true, :node => false }}
    let(:params) { default_params }

    it { should contain_anchor('slurm::start').that_comes_before('Class[slurm::client]') }
    it { should contain_class('slurm::client').that_comes_before('Anchor[slurm::end]') }
    it { should contain_anchor('slurm::end') }

    it { should_not contain_class('slurm::node') }
    it { should_not contain_class('slurm::controller') }
    it { should_not contain_class('slurm::slurmdbd') }

    it_behaves_like 'slurm::client'
  end

  context 'slurmdbd' do
    let(:default_params) {{ :slurmdbd => true, :node => false }}
    let(:params) { default_params }

    it { should contain_anchor('slurm::start').that_comes_before('Class[slurm::slurmdbd]') }
    it { should contain_class('slurm::slurmdbd').that_comes_before('Anchor[slurm::end]') }
    it { should contain_anchor('slurm::end') }

    it { should_not contain_class('slurm::node') }
    it { should_not contain_class('slurm::controller') }
    it { should_not contain_class('slurm::client') }

    it_behaves_like 'slurm::slurmdbd'
  end

  # Test validate_bool parameters
  [
    'manage_slurm_conf',
    'manage_scripts',
    'manage_state_dir_nfs_mount',
    'manage_job_checkpoint_dir_nfs_mount',
    'manage_slurm_user',
    'install_pam',
    'manage_cgroup_release_agents',
    'purge_plugstack_conf_d',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it "should raise an error" do
        expect { should compile }.to raise_error(/is not a boolean/)
      end
    end
  end

  # Test validate_array parameters
  [
    'partitionlist',
  ].each do |p|
    context "when #{p} => 'foo'" do
      let(:params) {{ p => 'foo' }}
      it "should raise an error" do
        expect { should compile }.to raise_error(/is not an Array/)
      end
    end
  end

  # Test validate_hash parameters
  [
    'slurm_conf_override',
    'slurmdbd_conf_override',
    'spank_plugins',
  ].each do |p|
    context "when #{p} => 'foo'" do
      let(:params) {{ p => 'foo' }}
      it "should raise an error" do
        expect { should compile }.to raise_error(/is not a Hash/)
      end
    end
  end
end
