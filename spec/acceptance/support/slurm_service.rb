shared_examples_for "slurm::service - running" do |node|
  describe service('slurm'), :node => node do
    it { should be_enabled }
    it { should be_running }
  end
end

shared_examples_for "slurm::service - stopped" do |node|
  describe service('slurm'), :node => node do
    it { should_not be_enabled }
    pending "slurm will return 0 when system not in slurm.conf" do
      it { should_not be_running }
    end
  end
end
