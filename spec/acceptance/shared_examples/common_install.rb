shared_examples_for 'common::install' do |node|
  [
    'slurm',
    'slurm-contribs',
    'slurm-devel',
    'slurm-example-configs',
    'slurm-perlapi',
    'slurm-libpmi',
    'slurm-pam_slurm',
  ].each do |p|
    describe package(p), node: node do
      it { is_expected.to be_installed.with_version(RSpec.configuration.slurm_package_version.to_s) }
    end
  end
end

shared_examples_for 'common::install-slurmd' do |node|
  describe package('slurm-slurmd'), node: node do
    it { is_expected.to be_installed.with_version(RSpec.configuration.slurm_package_version.to_s) }
  end
end
shared_examples_for 'common::install-slurmctld' do |node|
  describe package('slurm-slurmctld'), node: node do
    it { is_expected.to be_installed.with_version(RSpec.configuration.slurm_package_version.to_s) }
  end
end
shared_examples_for 'common::install-slurmdbd' do |node|
  describe package('slurm-slurmdbd'), node: node do
    it { is_expected.to be_installed.with_version(RSpec.configuration.slurm_package_version.to_s) }
  end
end
