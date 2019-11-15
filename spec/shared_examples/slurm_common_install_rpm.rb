def base_packages
  [
    'slurm',
    'slurm-contribs',
    'slurm-devel',
    'slurm-example-configs',
    'slurm-perlapi',
    'slurm-libpmi',
    'slurm-pam_slurm',
    'slurm-torque',
  ]
end

shared_examples_for 'slurm::common::install::rpm' do
  base_packages.each do |p|
    it { is_expected.to contain_package(p).with_ensure('present').without_require }
  end

  it { is_expected.not_to contain_yumrepo('slurm') }

  context 'when version => "19.05.3-2.el7"' do
    let(:params) { param_override.merge(version: '19.05.3-2.el7') }

    base_packages.each do |p|
      it { is_expected.to contain_package(p).with_ensure('19.05.3-2.el7').without_require }
    end
  end

  context 'when repo_baseurl defined' do
    let(:params) { param_override.merge(repo_baseurl: 'http://foo') }

    it { is_expected.to contain_yumrepo('slurm').with_baseurl('http://foo') }

    base_packages.each do |p|
      it { is_expected.to contain_package(p).with_ensure('present').with_require('Yumrepo[slurm]') }
    end
  end

  context 'when install_pam => false' do
    let(:params) { param_override.merge(install_pam: false) }

    it { is_expected.not_to contain_package('slurm-pam_slurm') }
  end

  context 'when install_torque_wrapper => false' do
    let(:params) { param_override.merge(install_torque_wrapper: false) }

    it { is_expected.not_to contain_package('slurm-torque') }
  end
end

shared_examples_for 'slurm::common::install::rpm-slurmd' do
  it { is_expected.to contain_package('slurm-slurmd').with_ensure('present').without_require }
end
shared_examples_for 'slurm::common::install::rpm-slurmctld' do
  it { is_expected.to contain_package('slurm-slurmctld').with_ensure('present').without_require }
end
shared_examples_for 'slurm::common::install::rpm-slurmdbd' do
  it { is_expected.to contain_package('slurm-slurmdbd').with_ensure('present').without_require }
end
