shared_examples_for 'slurmctld::config' do |node|
  describe file('/var/log/slurm'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 700 }
    it { is_expected.to be_owned_by slurm_user }
    it { is_expected.to be_grouped_into slurm_user }
  end

  describe file('/var/spool/slurmctld.state'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 700 }
    it { is_expected.to be_owned_by slurm_user }
    it { is_expected.to be_grouped_into slurm_user }
  end

  describe file('/var/spool/slurmctld.checkpoint'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 700 }
    it { is_expected.to be_owned_by slurm_user }
    it { is_expected.to be_grouped_into slurm_user }
  end
end
