shared_examples_for "slurm::config::common" do |node|
  describe file('/etc/slurm'), :node => node do
    it { should be_linked_to '/home/slurm/conf' }
  end

  describe file('/home/slurm/conf'), :node => node do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'slurm' }
    it { should be_grouped_into 'slurm' }
  end

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
end
