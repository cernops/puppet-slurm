shared_examples_for "slurm::install" do |node|
  [
    'slurm',
    'slurm-munge',
    'slurm-plugins',
    'slurm-torque',
  ].each do |p|
    describe package(p), :node => node do
      it { should be_installed.with_version("#{RSpec.configuration.slurm_package_version}") }
    end
  end
end
