require 'spec_helper_acceptance'

describe 'slurm::client class:' do
  context 'default parameters' do
    node = only_host_with_role(hosts, 'slurm_client')

    it 'should run successfully' do
      pp =<<-EOS
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
        package_require       => 'Yumrepo[slurm]',
        slurm_package_ensure  => '#{RSpec.configuration.slurm_package_version}',
        control_machine       => 'slurm-controller',
        partitionlist         => [
          {'PartitionName' => 'general', 'Default' => 'YES', 'Nodes' => 'slurm-node1'},
        ],
      }
      class { 'slurm::client': }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    it_behaves_like "slurm::user", node
    it_behaves_like "munge", node
    it_behaves_like "slurm::install", node
    it_behaves_like "slurm::config::common", node
    it_behaves_like "slurm::config", node
    it_behaves_like "slurm::service - stopped", node
  end
end