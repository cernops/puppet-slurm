shared_examples_for "slurm::common::user" do |node|
  describe group('slurm'), :node => node do
    it { should exist }
  end

  describe user('slurm'), :node => node do
    it { should exist }
  end
end
