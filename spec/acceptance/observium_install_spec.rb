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

  describe file('/opt/observium/config.php') do
    it { is_expected.to be_file }
    it { is_expected.to contain "$config['install_dir'] = \"/opt/observium\"" }
    it { is_expected.to contain "$config['db_host']      = 'localhost';" }
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe cron do
    it { should have_entry('33 */6 * * * /opt/observium/discovery.php -h all >> /dev/null 2>&1').with_user('root') }
  end

  describe cron do
    it { should have_entry('*/5 * * * * /opt/observium/discovery.php -h new >> /dev/null 2>&1').with_user('root') }
  end

  describe cron do
    it { should have_entry('*/5 * * * * /opt/observium/poller-wrapper.py >> /dev/null 2>&1').with_user('root') }
  end

  describe cron do
    it { should have_entry('5 13 * * * /opt/observium/housekeeping.php -ysel').with_user('root') }
  end

  describe cron do
    it { should have_entry('47 4 * * * /opt/observium/housekeeping.php -yrptb').with_user('root') }
  end

  # Red hat specifc checks
  if os[:family] == 'redhat'

    describe service('httpd') do
      it { is_expected.to be_running }
    end

    describe service('snmpd') do
      it { is_expected.to be_running }
    end

    describe package('python3-PyMySQL') do
      it { should be_installed }
    end

    describe yumrepo('opennms-common') do
      it { should exist }
    end

    describe yumrepo('epel') do
      it { should exist }
    end

  elsif os[:family] == 'ubuntu'

    describe service('apache2') do
      it { is_expected.to be_running }
    end

    describe service('snmpd') do
      it { is_expected.to be_running }
    end

    describe package(os:[release]) do
      it { should be_installed }
    end

  end
end
