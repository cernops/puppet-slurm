shared_examples_for 'slurmdbd::config' do |node|
  describe file('/var/log/slurm'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 700 }
    it { is_expected.to be_owned_by slurm_user }
    it { is_expected.to be_grouped_into slurm_user }
  end

  describe file('/etc/slurm/slurmdbd.conf'), node: node do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 600 }
    it { is_expected.to be_owned_by slurm_user }
    it { is_expected.to be_grouped_into slurm_user }
  end
end
