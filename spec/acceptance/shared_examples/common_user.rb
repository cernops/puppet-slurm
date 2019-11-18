shared_examples_for 'common::user' do |node|
  describe group('slurm'), node: node, unless: fact('virtual') == 'docker' do
    it { is_expected.to exist }
  end

  describe user('slurm'), node: node, unless: fact('virtual') == 'docker' do
    it { is_expected.to exist }
  end
end
