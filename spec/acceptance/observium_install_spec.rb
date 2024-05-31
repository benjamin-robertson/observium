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
      its(:content) { should contain '$config[\'install_dir\'] = "/opt/observium"' }
      its(:content) { should contain '$config[\'db_host\']      = \'localhost\';' }
    end
  
    describe port(80) do
      it { is_expected.to be_listening }
    end

    # Red hat specifc checks
    if os[:family] == 'redhat'

      descrube service('httpd') do
        it { should be_running }
      end

      descrube service('snmpd') do
        it { should be_running }
      end

    elsif os[:family] == 'ubuntu'

      descrube service('apache2') do
        it { should be_running }
      end

      descrube service('snmpd') do
        it { should be_running }
      end

    end

end