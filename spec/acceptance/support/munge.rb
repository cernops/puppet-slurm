shared_examples_for 'munge' do |node|
  describe package('munge'), node: node do
    it { is_expected.to be_installed }
  end

  describe file('/etc/munge/munge.key'), node: node do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 400 }
    it { is_expected.to be_owned_by 'munge' }
    it { is_expected.to be_grouped_into 'munge' }
  end

  describe service('munge'), node: node do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
