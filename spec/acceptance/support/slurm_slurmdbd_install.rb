shared_examples_for "slurm::slurmdbd::install" do |node|
  [
    'slurm-slurmdbd',
    'slurm-sql',
  ].each do |p|
    describe package(p), :node => node do
      it { should be_installed.with_version("#{RSpec.configuration.slurm_package_version}") }
    end
  end
end
