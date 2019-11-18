shared_examples_for 'slurmdbd::service' do |node|
  describe service('slurmdbd'), node: node do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
