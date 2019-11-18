shared_examples_for 'common::config' do |node|
  describe file('/etc/slurm/slurm.conf'), node: node do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match %r{^Include /etc/slurm/nodes.conf$} }
    its(:content) { is_expected.to match %r{^Include /etc/slurm/partitions.conf$} }
  end

  describe file('/etc/slurm/nodes.conf'), node: node do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match %r{^NodeName=slurmd1 CPUs=1 State=UNKNOWN$} }
    its(:content) { is_expected.to match %r{^NodeName=slurmd2 CPUs=1 State=UNKNOWN$} }
  end

  describe file('/etc/slurm/partitions.conf'), node: node do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match %r{^PartitionName=general Default=YES Nodes=slurmd\[1-2\] State=UP$} }
  end

  describe file('/etc/slurm/plugstack.conf.d'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe file('/etc/slurm/plugstack.conf'), node: node do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match %r{^include /etc/slurm/plugstack.conf.d/\*.conf$} }
  end

  describe linux_kernel_parameter('net.core.somaxconn'), node: node do
    its(:value) { is_expected.to eq 1024 }
  end
end
