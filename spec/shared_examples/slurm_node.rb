shared_examples_for 'slurm::node' do

  it { should contain_class('munge').that_comes_before('Class[slurm::common::user]') }
  it { should contain_class('slurm::common::user').that_comes_before('Class[slurm::common::install]') }
  it { should contain_class('slurm::common::install').that_comes_before('Class[slurm::common::setup]') }
  it { should contain_class('slurm::common::setup').that_comes_before('Class[slurm::common::config]') }
  it { should contain_class('slurm::common::config').that_comes_before('Class[slurm::node::config]') }
  it { should contain_class('slurm::node::config').that_notifies('Class[slurm::node::service]') }
  it { should contain_class('slurm::node::service') }

  it { should contain_class('slurm::common::install').that_notifies('Class[slurm::node::service]') }
  it { should contain_class('slurm::common::setup').that_notifies('Class[slurm::node::service]') }
  it { should contain_class('slurm::common::config').that_notifies('Class[slurm::node::service]') }

  it_behaves_like 'slurm::common::user'
  it_behaves_like 'slurm::common::install::rpm'
  it_behaves_like 'slurm::common::install::rpm-slurmd'
  it_behaves_like 'slurm::common::setup'
  it_behaves_like 'slurm::common::config'
  it_behaves_like 'slurm::node::config'
  it_behaves_like 'slurm::node::service'

  it do
    should contain_firewall('100 allow access to slurmd').with({
      :proto  => 'tcp',
      :dport  => '6818',
      :action => 'accept',
    })
  end

  context 'when manage_firewall => false' do
    let(:params) { param_override.merge({ :manage_firewall => false }) }
    it { should_not contain_firewall('100 allow access to slurmd') }
  end
end
