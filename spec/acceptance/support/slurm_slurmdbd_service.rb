shared_examples_for "slurm::slurmdbd::service" do |node|
  describe service('slurmdbd'), :node => node do
    it { should be_enabled }
    it { should be_running }
  end
end
