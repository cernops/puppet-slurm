shared_examples_for 'slurm::service - running' do |node|
  describe service('slurm'), node: node do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end

shared_examples_for 'slurm::service - stopped' do |node|
  describe process('slurmd'), node: node do
    it { is_expected.not_to be_running }
  end

  describe process('slurmctld'), node: node do
    it { is_expected.not_to be_running }
  end
end
