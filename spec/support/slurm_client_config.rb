shared_examples 'slurm::client::config' do
  let(:params) { context_params }

  it_behaves_like 'slurm_conf_common'
  it_behaves_like 'slurm_conf_partitions'
end
