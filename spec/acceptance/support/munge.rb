shared_examples_for "munge" do |node|
  describe package('munge'), :node => node do
    it { should be_installed }
  end

  describe file('/etc/munge/munge.key'), :node => node do
    it { should be_file }
    it { should be_mode 400 }
    it { should be_owned_by 'munge' }
    it { should be_grouped_into 'munge' }
  end

  describe service('munge'), :node => node do
    it { should be_enabled }
    it { should be_running }
  end
end
