shared_examples_for 'slurm::controller::config' do |node|
  [
    '/var/log/slurm',
    '/var/run/slurm',
    '/var/lib/slurm',
  ].each do |d|
    describe file(d), node: node do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode 700 }
      it { is_expected.to be_owned_by 'slurm' }
      it { is_expected.to be_grouped_into 'slurm' }
    end
  end

  describe file('/var/lib/slurm/state'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 700 }
    it { is_expected.to be_owned_by 'slurm' }
    it { is_expected.to be_grouped_into 'slurm' }
  end

  describe file('/var/lib/slurm/checkpoint'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 700 }
    it { is_expected.to be_owned_by 'slurm' }
    it { is_expected.to be_grouped_into 'slurm' }
  end

  # TODO: Test logrotate::rule
end
