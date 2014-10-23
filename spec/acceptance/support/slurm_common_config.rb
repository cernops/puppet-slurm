shared_examples_for "slurm::common::config" do |node|
  describe file('/home/slurm/conf/slurm.conf'), :node => node do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^Include \/home\/slurm\/conf\/nodes.conf$/ }
    its(:content) { should match /^Include \/home\/slurm\/conf\/partitions.conf$/ }
  end

  describe file('/home/slurm/conf/nodes.conf'), :node => node do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^NodeName=slurm-node1.*$/ }
  end

  describe file('/home/slurm/conf/partitions.conf'), :node => node do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^PartitionName=general Nodes=slurm-node1 Default=YES$/ }
  end

  describe file('/home/slurm/conf/plugstack.conf.d'), :node => node do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/home/slurm/conf/plugstack.conf'), :node => node do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    # TODO: Test contents
  end

  describe linux_kernel_parameter('net.core.somaxconn'), :node => node do 
    its(:value) { should eq 1024 }
  end
end
