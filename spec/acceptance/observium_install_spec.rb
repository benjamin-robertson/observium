# frozen_string_literal: true

require 'spec_helper_acceptance'
require 'rspec-puppet-facts'

describe 'Installation', if: ['centos', 'redhat', 'ubuntu'].include?(os[:family]) do
    before(:all) do
      if os[:family] == 'redhat'
        install_packge('crontabs')
      elsif os[:family] == 'ubuntu'
        install_packge('cron')
      end
    end

    let(:hiera_config) { 'hiera-rpsec.yaml' }

    let(:pp) do
      <<-MANIFEST
        include observium
      MANIFEST
    end
  
    it 'applies idempotently' do
      idempotent_apply(pp)
    end
  
    describe file("/opt/observium/config.php") do
      it { is_expected.to be_file }
    #   its(:content) { is_expected.to match %r{key = default value} }
    end
  
    describe port(80) do
      it { is_expected.to be_listening }
    end
end