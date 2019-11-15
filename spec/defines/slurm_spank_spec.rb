require 'spec_helper'

describe 'slurm::spank' do
  on_supported_os({
    supported_os: [
      {
        'operatingsystem'        => 'RedHat',
        'operatingsystemrelease' => ['7'],
      }
    ],
  }).each do |os, os_facts|
    let(:facts) { os_facts }
    let(:title) { "x11" }
    let(:params) {{ }}
    let(:pre_condition) { "class { 'slurm': node => true }" }

    it { should create_slurm__spank('x11') }
    it { should contain_class('slurm') }

    it do
      should contain_package('SLURM SPANK x11 package').only_with({
        :ensure => 'installed',
        :name   => 'slurm-spank-x11',
        :before => 'File[SLURM SPANK x11 config]',
      })
    end

    it do
      should contain_file('SLURM SPANK x11 config').only_with({
        :ensure   => 'file',
        :path     => '/etc/slurm/plugstack.conf.d/x11.conf',
        :owner    => 'root',
        :group    => 'root',
        :mode     => '0644',
        :content  => /^optional x11.so$/,
      })
    end

    context 'when required => true' do
      let(:params) {{ :required => true }}

      it do
        verify_contents(catalogue, 'SLURM SPANK x11 config', [
          'required x11.so',
        ])
      end
    end

    context 'when manage_package => false' do
      let(:params) {{ :manage_package => false }}

      it { should_not contain_package('SLURM SPANK x11 package') }
    end

    context 'when arguments specified' do
      let(:params) {{ :arguments => {'ssh_cmd' => 'ssh', 'helpertask_cmd' => '2>/tmp/log'} }}

      it do
        verify_contents(catalogue, 'SLURM SPANK x11 config', [
          'optional x11.so helpertask_cmd=2>/tmp/log ssh_cmd=ssh',
        ])
      end
    end

    context 'when restart_slurmd => true' do
      let(:params) {{ :restart_slurmd => true }}

      it { should contain_package('SLURM SPANK x11 package').with_notify('Service[slurmd]') }
      it { should contain_file('SLURM SPANK x11 config').with_notify('Service[slurmd]') }
    end

    describe "auks example" do
      let(:title) { "auks" }
      let(:params) {{
        :required => true,
        :arguments => {
          'conf' => '/etc/auks/auks.conf',
          'default' => 'enabled',
          'spankstackcred' => 'no',
          'minimum_uid' => '0',
        },
        :package_name => 'auks-slurm',
      }}

      it { should contain_package('SLURM SPANK auks package').with_name('auks-slurm') }

      it do
        verify_contents(catalogue, 'SLURM SPANK auks config', [
          'required auks.so conf=/etc/auks/auks.conf default=enabled minimum_uid=0 spankstackcred=no',
        ])
      end
    end
  end
end
