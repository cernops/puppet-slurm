shared_examples_for 'slurm::common::install' do |node|
  [
    'slurm',
    'slurm-devel',
    'slurm-munge',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-sjobexit',
    'slurm-sjstat',
    'slurm-torque',
  ].each do |p|
    describe package(p), node: node do
      it { is_expected.to be_installed.with_version(RSpec.configuration.slurm_package_version.to_s) }
    end
  end
end

shared_examples_for 'slurm::common::install-slurmdbd' do |node|
  [
    'slurm-slurmdbd',
    'slurm-sql',
  ].each do |p|
    describe package(p), node: node do
      it { is_expected.to be_installed.with_version(RSpec.configuration.slurm_package_version.to_s) }
    end
  end
end
