require 'spec_helper_acceptance'

describe 'slurmd' do
  if fact('virtual') == 'docker'
    let(:slurm_user) { 'root' }
  else
    let(:slurm_user) { 'slurm' }
  end

  context 'default parameters' do
    nodes = hosts_as('slurmd')

    it 'runs successfully' do
      pp = <<-EOS
      class { 'slurm':
        client => false,
        slurmd => true,
      }
      EOS

      apply_manifest_on(nodes, pp, catch_failures: true)
      if fact('virtual') == 'docker'
        on nodes, 'chown root:root /run/munge'
      end
      apply_manifest_on(nodes, pp, catch_changes: true)
    end

    nodes.each do |node|
      it_behaves_like 'common::user', node
      it_behaves_like 'common::install', node
      it_behaves_like 'common::install-slurmd', node
      it_behaves_like 'common::setup', node
      it_behaves_like 'common::config', node
      it_behaves_like 'slurmd::config', node
      it_behaves_like 'slurmd::service', node
    end
  end
end
