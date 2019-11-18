shared_examples_for 'slurmctld::service' do |node|
  describe service('slurmctld'), node: node do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
