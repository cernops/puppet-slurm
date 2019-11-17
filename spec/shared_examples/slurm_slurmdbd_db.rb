shared_examples_for 'slurm::slurmdbd::db' do
  it do
    is_expected.to contain_mysql__db('slurm_acct_db').with(user: 'slurmdbd',
                                                           password: 'slurmdbd',
                                                           host: 'localhost',
                                                           grant: ['ALL'])
  end

  context 'when export_database => true' do
    let(:param_override) {  { export_database: true } }

    it { is_expected.not_to contain_mysql__db('slurm_acct_db') }
  end

  context 'when manage_database => false' do
    let(:param_override) {  { manage_database: false } }

    it { is_expected.not_to contain_mysql__db('slurm_acct_db') }
  end
end
