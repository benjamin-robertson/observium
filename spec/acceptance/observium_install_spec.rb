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

    # let(:hiera_config) { 'hiera-rpsec.yaml' } # serverspec doesn't seem to respect this.

    let(:pp) do
      <<-MANIFEST
        class { 'observium':
          snmpd_agentaddress => ['udp:127.0.0.1:161']
        }
      MANIFEST
    end
  
    it 'applies idempotently' do
      idempotent_apply(pp)
    end
  
    describe file("/opt/observium/config.php") do
      it { is_expected.to be_file }
      it { should contain "$config['install_dir'] = \"/opt/observium\"" }
      it { should contain "$config['db_host']      = 'localhost';" }
    end
  
    describe port(80) do
      it { is_expected.to be_listening }
    end

    # Red hat specifc checks
    if os[:family] == 'redhat'

      describe service('httpd') do
        it { should be_running }
      end

      describe service('snmpd') do
        it { should be_running }
      end

    elsif os[:family] == 'ubuntu'

      describe service('apache2') do
        it { should be_running }
      end

      describe service('snmpd') do
        it { should be_running }
      end

    end

end