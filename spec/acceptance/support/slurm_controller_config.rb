shared_examples_for "slurm::controller::config" do |node|
  [
    '/var/log/slurm',
    '/var/run/slurm',
    '/var/lib/slurm',
  ].each do |d|
    describe file(d), :node => node do
      it { should be_directory }
      it { should be_mode 700 }
      it { should be_owned_by 'slurm' }
      it { should be_grouped_into 'slurm' }
    end
  end

  describe file('/var/lib/slurm/state'), :node => node do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by 'slurm' }
    it { should be_grouped_into 'slurm' }
  end

  describe file('/var/lib/slurm/checkpoint'), :node => node do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by 'slurm' }
    it { should be_grouped_into 'slurm' }
  end

  #TODO: Test logrotate::rule
end
