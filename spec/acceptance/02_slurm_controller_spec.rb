require 'spec_helper_acceptance'

describe 'controller' do
  context 'default parameters' do
    node = only_host_with_role(hosts, 'slurm_controller')

    it 'runs successfully' do
      pp = <<-EOS
      class { 'munge':
        munge_key_source => 'puppet:///modules/site_slurm/munge.key',
      }
      yumrepo { 'slurm':
        descr     => 'slurm',
        enabled   => '1',
        gpgcheck  => '0',
        baseurl   => '#{RSpec.configuration.slurm_yumrepo_baseurl}',
      }
      class { 'slurm':
        node                  => false,
        controller            => true,
        package_require       => 'Yumrepo[slurm]',
        version               => '#{RSpec.configuration.slurm_package_version}',
        control_machine       => 'slurm-controller',
        partitionlist         => [
          {'PartitionName' => 'general', 'Default' => 'YES', 'Nodes' => 'slurm-node1'},
        ],
      }
      EOS

      apply_manifest_on(node, pp, catch_failures: true)
      apply_manifest_on(node, pp, catch_changes: true)
    end

    it_behaves_like 'munge', node
    it_behaves_like 'slurm::common::user', node
    it_behaves_like 'slurm::common::install', node
    it_behaves_like 'slurm::common::setup', node
    it_behaves_like 'slurm::common::config', node
    it_behaves_like 'slurm::controller::config', node
    it_behaves_like 'slurm::service - running', node
  end
end
