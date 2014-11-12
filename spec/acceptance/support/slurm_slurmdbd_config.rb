shared_examples_for "slurm::slurmdbd::config" do |node|
  #TODO: Test MySQL resources

  describe file('/etc/slurm/slurmdbd.conf'), :node => node do
    it { should be_file }
    it { should be_mode 600 }
    it { should be_owned_by 'slurm' }
    it { should be_grouped_into 'slurm' }
    #TODO: Test contents
  end

  #TODO: Test logrotate::rule
end
