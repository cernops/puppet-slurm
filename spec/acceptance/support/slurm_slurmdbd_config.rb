shared_examples_for 'slurm::slurmdbd::config' do |node|
  # TODO: Test MySQL resources

  describe file('/etc/slurm/slurmdbd.conf'), node: node do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 600 }
    it { is_expected.to be_owned_by 'slurm' }
    it { is_expected.to be_grouped_into 'slurm' }
    # TODO: Test contents
  end

  # TODO: Test logrotate::rule
end
