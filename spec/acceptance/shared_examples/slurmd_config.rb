shared_examples_for 'slurmd::config' do |node|
  describe file('/var/log/slurm'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 700 }
    it { is_expected.to be_owned_by slurm_user }
    it { is_expected.to be_grouped_into slurm_user }
  end
  describe file('/var/spool/slurmd'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end
end
