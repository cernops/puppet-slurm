shared_examples_for 'slurm::node' do

  it { should contain_anchor('slurm::node::start').that_comes_before('Class[munge]') }
  it { should contain_class('munge').that_comes_before('Class[slurm::common::user]') }
  it { should contain_class('slurm::common::user').that_comes_before('Class[slurm::common::install]') }
  it { should contain_class('slurm::common::install').that_comes_before('Class[slurm::node::config]') }
  it { should contain_class('slurm::node::config').that_comes_before('Class[slurm::common::setup]') }
  it { should contain_class('slurm::common::setup').that_comes_before('Class[slurm::node::cgroups]') }
  it { should contain_class('slurm::node::cgroups').that_comes_before('Class[slurm::common::config]') }
  it { should contain_class('slurm::common::config').that_comes_before('Class[slurm::node::service]') }
  it { should contain_class('slurm::node::service').that_comes_before('Anchor[slurm::node::end]') }
  it { should contain_anchor('slurm::node::end') }

  it_behaves_like 'slurm::common::user'
  it_behaves_like 'slurm::common::install'
  it_behaves_like 'slurm::node::config'
  it_behaves_like 'slurm::common::setup'
  it_behaves_like 'slurm::node::cgroups'
  it_behaves_like 'slurm::common::config'
  it_behaves_like 'slurm::node::service'

  context 'when include_blcr => true' do
    let(:params) { default_params.merge({ :include_blcr => true }) }

    it { should contain_anchor('slurm::node::start').that_comes_before('Class[munge]') }
    it { should contain_class('munge').that_comes_before('Class[blcr]') }
    it { should contain_class('blcr').that_comes_before('Class[slurm::common::user]') }
    it { should contain_class('slurm::common::user').that_comes_before('Class[slurm::common::install]') }
    it { should contain_class('slurm::common::install').that_comes_before('Class[slurm::node::config]') }
    it { should contain_class('slurm::node::config').that_comes_before('Class[slurm::common::setup]') }
    it { should contain_class('slurm::common::setup').that_comes_before('Class[slurm::node::cgroups]') }
    it { should contain_class('slurm::node::cgroups').that_comes_before('Class[slurm::common::config]') }
    it { should contain_class('slurm::common::config').that_comes_before('Class[slurm::node::service]') }
    it { should contain_class('slurm::node::service').that_comes_before('Anchor[slurm::node::end]') }
    it { should contain_anchor('slurm::node::end') }
  end

  it do
    should contain_firewall('100 allow access to slurmd').with({
      :proto  => 'tcp',
      :dport  => '6818',
      :action => 'accept',
    })
  end

  context 'when manage_firewall => false' do
    let(:params) { default_params.merge({ :manage_firewall => false }) }
    it { should_not contain_firewall('100 allow access to slurmd') }
  end
end
