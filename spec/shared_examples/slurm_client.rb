shared_examples_for 'slurm::client' do

  it { should contain_class('munge').that_comes_before('Class[slurm::common::user]') }
  it { should contain_class('slurm::common::user').that_comes_before('Class[slurm::common::install]') }
  it { should contain_class('slurm::common::install').that_comes_before('Class[slurm::common::setup]') }
  it { should contain_class('slurm::common::setup').that_comes_before('Class[slurm::common::config]') }
  it { should contain_class('slurm::common::config') }

  it_behaves_like 'slurm::common::user'
  it_behaves_like 'slurm::common::install::rpm'
  it_behaves_like 'slurm::common::setup'
  it_behaves_like 'slurm::common::config'
end
