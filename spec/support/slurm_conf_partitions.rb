shared_examples 'slurm_conf_partitions' do
  let(:params) { context_params }

  it { should contain_concat_fragment('slurm.conf+03-partitions') }

  context 'when partitionlist defined' do
    let(:params) { context_params.merge({
      :partitionlist => [
        {
          'PartitionName' => 'DEFAULT',
          'Nodes'         => 'c[0-9]',
          'State'         => 'UP',
        },
        {
          'PartitionName' => 'general',
          'Priority'      => '3',
          'MaxNodes'      => '1',
          'MaxTime'       => '48:00:00',
          'Default'       => 'YES',
        }
      ]
    })}

    it do
      content = catalogue.resource('concat_fragment', "slurm.conf+03-partitions").send(:parameters)[:content]
      expected_lines = [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=general Default=YES Priority=3 MaxNodes=1 MaxTime=48:00:00",
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context 'when partitionlist_content defined' do
    let(:params) { context_params.merge({ :partitionlist_content => 'site_slurm/slurm.conf/partitions.erb' }) }

    it do
      content = catalogue.resource('concat_fragment', "slurm.conf+03-partitions").send(:parameters)[:content]
      expected_lines = [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=ib Nodes=c[0101-0102] Priority=6 MaxTime=12:00:00 State=UP",
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context "partitionlist hierarchy - partitionlist_content first" do
    let :params do
      context_params.merge({
        :partitionlist => [
          {
            'PartitionName' => 'DEFAULT',
            'Nodes'         => 'c[0-9]',
            'State'         => 'UP',
          },
          {
            'PartitionName' => 'general',
            'Priority'      => '3',
            'MaxNodes'      => '1',
            'MaxTime'       => '48:00:00',
            'Default'       => 'YES',
          }
        ],
        :partitionlist_content => 'site_slurm/slurm.conf/partitions.erb',
      })
    end

    it "slurm.conf-partitions should use partitionlist_content" do
      content = catalogue.resource('concat_fragment', "slurm.conf+03-partitions").send(:parameters)[:content]
      expected_lines = [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=ib Nodes=c[0101-0102] Priority=6 MaxTime=12:00:00 State=UP",
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context "partitionlist hierarchy - partitionlist last" do
    let :params do
      context_params.merge({
        :partitionlist => [
          {
            'PartitionName' => 'DEFAULT',
            'Nodes'         => 'c[0-9]',
            'State'         => 'UP',
          },
          {
            'PartitionName' => 'general',
            'Priority'      => '3',
            'MaxNodes'      => '1',
            'MaxTime'       => '48:00:00',
            'Default'       => 'YES',
          }
        ],
        :partitionlist_content => false,
      })
    end

    it "slurm.conf-partitions should use partitionlist_content" do
      content = catalogue.resource('concat_fragment', "slurm.conf+03-partitions").send(:parameters)[:content]
      expected_lines = [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=general Default=YES Priority=3 MaxNodes=1 MaxTime=48:00:00",
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context 'when slurm_conf_source defined' do
    let(:params) { context_params.merge({ :slurm_conf_source => 'puppet:///modules/site_slurm/slurm.conf'}) }

    it { should_not contain_concat_fragment('slurm.conf+03-partitions') }
  end
end
