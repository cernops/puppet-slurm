shared_examples_for 'slurmd::service' do |node|
  describe service('slurmd'), node: node do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
