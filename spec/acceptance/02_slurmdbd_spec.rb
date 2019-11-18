require 'spec_helper_acceptance'

describe 'slurmdbd' do
  if fact('virtual') == 'docker'
    let(:slurm_user) { 'root' }
  else
    let(:slurm_user) { 'slurm' }
  end

  context 'default parameters' do
    nodes = hosts_as('slurmdbd')

    it 'runs successfully' do
      pp = <<-EOS
      include mysql::server
      class { 'slurm':
        client => false,
        slurmdbd => true,
        database => true,
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
      it_behaves_like 'common::install-slurmdbd', node
      it_behaves_like 'common::setup', node
      it_behaves_like 'slurmdbd::config', node
      it_behaves_like 'slurmdbd::service', node
    end
  end
end
