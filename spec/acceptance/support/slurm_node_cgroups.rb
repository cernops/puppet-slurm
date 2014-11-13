shared_examples_for "slurm::node::cgroups" do |node|
  describe file('/etc/slurm/cgroup'), :node => node do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/slurm/cgroup/release_common'), :node => node do
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  [
    'release_blkio',
    'release_cpuacct',
    'release_cpuset',
    'release_freezer',
    'release_memory',
    'release_devices',
  ].each do |f|
    describe file("/etc/slurm/cgroup/#{f}"), :node => node do
      it { should be_linked_to 'release_common' }
    end
  end
end
