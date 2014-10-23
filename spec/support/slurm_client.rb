shared_examples_for 'slurm::client' do

  it { should contain_anchor('slurm::client::start').that_comes_before('Class[munge]') }
  it { should contain_class('munge').that_comes_before('Class[slurm::common::user]') }
  it { should contain_class('slurm::common::user').that_comes_before('Class[slurm::common::install]') }
  it { should contain_class('slurm::common::install').that_comes_before('Class[slurm::common::setup]') }
  it { should contain_class('slurm::common::setup').that_comes_before('Class[slurm::common::config]') }
  it { should contain_class('slurm::common::config').that_comes_before('Class[slurm::client::service]') }
  it { should contain_class('slurm::client::service').that_comes_before('Anchor[slurm::client::end]') }
  it { should contain_anchor('slurm::client::end') }

  it_behaves_like 'slurm::common::user'
  it_behaves_like 'slurm::common::install'
  it_behaves_like 'slurm::common::setup'
  it_behaves_like 'slurm::common::config'
  it_behaves_like 'slurm::client::service'
end
