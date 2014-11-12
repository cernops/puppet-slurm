shared_examples_for "slurm::common::setup" do |node|
  describe file('/etc/profile.d/slurm.sh'), :node => node do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^export SLURM_CONF="\/etc\/slurm\/slurm.conf"$/ }
  end

  describe file('/etc/profile.d/slurm.csh'), :node => node do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^setenv SLURM_CONF="\/etc\/slurm\/slurm.conf"$/ }
  end

  # TODO: test /etc/sysconfig/slurm

  describe file('/etc/slurm'), :node => node do
    it { should be_directory }
    it { should be_mode 755 }
  end

end
