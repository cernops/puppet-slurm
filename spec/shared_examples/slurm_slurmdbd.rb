shared_examples_for 'slurm::slurmdbd' do
  it { is_expected.to contain_class('munge').that_comes_before('Class[slurm::common::user]') }
  it { is_expected.to contain_class('slurm::common::user').that_comes_before('Class[slurm::common::install]') }
  it { is_expected.to contain_class('slurm::common::install').that_comes_before('Class[slurm::common::setup]') }
  it { is_expected.to contain_class('slurm::common::setup').that_comes_before('Class[slurm::slurmdbd::config]') }
  it { is_expected.to contain_class('slurm::slurmdbd::config').that_comes_before('Class[slurm::slurmdbd::service]') }
  it { is_expected.to contain_class('slurm::slurmdbd::service') }

  it_behaves_like 'slurm::common::user'
  it_behaves_like 'slurm::common::install::rpm-slurmdbd'
  it_behaves_like 'slurm::common::setup'
  it_behaves_like 'slurm::slurmdbd::config'
  it_behaves_like 'slurm::slurmdbd::service'
end
