shared_examples_for 'common::setup' do |node|
  describe file('/etc/profile.d/slurm.sh'), node: node do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match %r{^export SLURM_CONF="/etc/slurm/slurm.conf"$} }
  end

  describe file('/etc/profile.d/slurm.csh'), node: node do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match %r{^setenv SLURM_CONF "/etc/slurm/slurm.conf"$} }
  end

  describe file('/etc/slurm'), node: node do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
  end
end
