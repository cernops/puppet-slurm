shared_examples 'slurm_conf_partitions' do
  let(:params) { context_params }

  it do
    should contain_concat__fragment('slurm.conf-partitions').with({
      :target => '/etc/slurm/slurm.conf',
      :order  => '3',
    })
  end

  it { should contain_file("#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions") }

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
      content = catalogue.resource('file', "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions").send(:parameters)[:content]
      config = content.split("\n").reject { |c| c =~ /(^#|^$)/ }
      config.should == [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=general Default=YES Priority=3 MaxNodes=1 MaxTime=48:00:00",
      ]
    end
  end

  context 'when partitionlist_content defined' do
    let(:params) { context_params.merge({ :partitionlist_content => 'site_slurm/slurm.conf/partitions.erb' }) }

    it do
      content = catalogue.resource('file', "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions").send(:parameters)[:content]
      config = content.split("\n").reject { |c| c =~ /(^#|^$)/ }
      config.should == [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=ib Nodes=c[0101-0102] Priority=6 MaxTime=12:00:00 State=UP",
      ]
    end
  end

  context 'when partitionlist_source defined' do
    let(:params) { context_params.merge({ :partitionlist_source => 'puppet:///modules/site_slurm/slurm.conf/partitions' }) }

    it do
      should contain_file("#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions").with({
        :source => 'puppet:///modules/site_slurm/slurm.conf/partitions',
      })
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
        :partitionlist_source => 'puppet:///modules/site_slurm/slurm.conf/partitions',
      })
    end

    it do
      should contain_concat__fragment('slurm.conf-partitions').with({
        :target => '/etc/slurm/slurm.conf',
        :source => nil,
        :order  => '3',
      })
    end

    it "slurm.conf-partitions should use partitionlist_content" do
      verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions", [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=ib Nodes=c[0101-0102] Priority=6 MaxTime=12:00:00 State=UP",
      ])
    end
  end

  context "partitionlist hierarchy - partitionlist_source second" do
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
        :partitionlist_source => 'puppet:///modules/site_slurm/slurm.conf/partitions',
      })
    end

    it do
      should contain_concat__fragment('slurm.conf-partitions').with({
        :target   => '/etc/slurm/slurm.conf',
        :content  => nil,
        :source   => 'puppet:///modules/site_slurm/slurm.conf/partitions',
        :order    => '3',
      })
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
        :partitionlist_source => false,
      })
    end

    it do
      should contain_concat__fragment('slurm.conf-partitions').with({
        :target => '/etc/slurm/slurm.conf',
        :source => nil,
        :order  => '3',
      })
    end

    it "slurm.conf-partitions should use partitionlist_content" do
      verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions", [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=general Default=YES Priority=3 MaxNodes=1 MaxTime=48:00:00",
      ])
    end
  end

  context 'when slurm_conf_source defined' do
    let(:params) { context_params.merge({ :slurm_conf_source => 'puppet:///modules/site_slurm/slurm.conf'}) }

    it { should_not contain_concat__fragment('slurm.conf-partitions') }
    it { should_not contain_file("#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions") }
  end
end
