shared_examples_for 'slurm::common::user' do |node|
  describe group('slurm'), node: node do
    it { is_expected.to exist }
  end

  describe user('slurm'), node: node do
    it { is_expected.to exist }
  end
end
