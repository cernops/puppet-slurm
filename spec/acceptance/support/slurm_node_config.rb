shared_examples_for "slurm::node::config" do |node|
  describe file('/var/spool/slurmd'), :node => node do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  #TODO: Test logrotate::rule
end
