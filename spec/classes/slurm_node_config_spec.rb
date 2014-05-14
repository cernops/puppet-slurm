require 'spec_helper'

describe 'slurm::node::config' do
  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::node::config') }
  it { should contain_class('slurm') }

  it do
    should contain_file('SlurmdSpoolDir').with({
      :ensure => 'directory',
      :path   => '/var/spool/slurmd',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
    })
  end

  it { should_not contain_file('epilog') }
  it { should_not contain_file('health_check_program') }
  it { should_not contain_file('prolog') }
  it { should_not contain_file('task_epilog') }
  it { should_not contain_file('task_prolog') }

  it do
    should contain_logrotate__rule('slurmd').with({
      :path          => '/var/log/slurm/slurmd.log',
      :compress      => 'true',
      :missingok     => 'true',
      :copytruncate  => 'false',
      :delaycompress => 'false',
      :ifempty       => 'false',
      :rotate        => '10',
      :sharedscripts => 'true',
      :size          => '10M',
      :create        => 'true',
      :create_mode   => '0640',
      :create_owner  => 'slurm',
      :create_group  => 'root',
      :postrotate    => '/etc/init.d/slurm reconfig >/dev/null 2>&1',
    })
  end

  context 'when manage_logrotate => false' do
    let(:params) {{ :manage_logrotate => false }}
    it { should_not contain_logrotate__rule('slurmd') }
  end

  context 'when epilog => /tmp/foo' do
    let(:pre_condition) { "class { 'slurm': epilog => '/tmp/foo' }" }

    it { should_not contain_file('epilog') }

    context 'when manage_scripts => true' do
      let(:params) {{ :manage_scripts => true }}
      
      it do
        should contain_file('epilog').with({
          :ensure => 'file',
          :path   => '/tmp/foo',
          :source => nil,
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0754',
        })
      end
    end
  end

  context 'when health_check_program => /tmp/nhc' do
    let(:pre_condition) { "class { 'slurm': health_check_program => '/tmp/nhc' }" }

    it { should_not contain_file('health_check_program') }

    context 'when manage_scripts => true' do
      let(:params) {{ :manage_scripts => true }}
      
      it do
        should contain_file('health_check_program').with({
          :ensure => 'file',
          :path   => '/tmp/nhc',
          :source => nil,
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0754',
        })
      end
    end
  end

  context 'when prolog => /tmp/bar' do
    let(:pre_condition) { "class { 'slurm': prolog => '/tmp/bar' }" }

    it { should_not contain_file('prolog') }

    context 'when manage_scripts => true' do
      let(:params) {{ :manage_scripts => true }}
      
      it do
        should contain_file('prolog').with({
          :ensure => 'file',
          :path   => '/tmp/bar',
          :source => nil,
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0754',
        })
      end
    end
  end

  context 'when task_epilog => /tmp/epilog' do
    let(:pre_condition) { "class { 'slurm': task_epilog => '/tmp/epilog' }" }

    it { should_not contain_file('task_epilog') }

    context 'when manage_scripts => true' do
      let(:params) {{ :manage_scripts => true }}
      
      it do
        should contain_file('task_epilog').with({
          :ensure => 'file',
          :path   => '/tmp/epilog',
          :source => nil,
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0754',
        })
      end
    end
  end

  context 'when task_prolog => /tmp/foobar' do
    let(:pre_condition) { "class { 'slurm': task_prolog => '/tmp/foobar' }" }

    it { should_not contain_file('task_prolog') }

    context 'when manage_scripts => true' do
      let(:params) {{ :manage_scripts => true }}
      
      it do
        should contain_file('task_prolog').with({
          :ensure => 'file',
          :path   => '/tmp/foobar',
          :source => nil,
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0754',
        })
      end
    end
  end
end
