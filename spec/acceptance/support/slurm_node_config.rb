shared_examples_for 'slurm::node::config' do |node|
  describe file('/etc/slurm/cgroup'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe file('/etc/slurm/cgroup/release_common'), node: node do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  [
    'release_blkio',
    'release_cpuacct',
    'release_cpuset',
    'release_freezer',
    'release_memory',
    'release_devices',
  ].each do |f|
    describe file("/etc/slurm/cgroup/#{f}"), node: node do
      it { is_expected.to be_linked_to 'release_common' }
    end
  end

  [
    '/var/log/slurm',
    '/var/run/slurm',
    '/var/lib/slurm',
  ].each do |d|
    describe file(d), node: node do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode 700 }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end
  end

  describe file('/var/spool/slurmd'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  # TODO: Test logrotate::rule
end
