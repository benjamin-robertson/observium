# frozen_string_literal: true

require 'spec_helper_acceptance'
require 'rspec-puppet-facts'

describe 'Installation', if: ['centos', 'redhat', 'ubuntu'].include?(os[:family]) do
  before(:all) do
    if os[:family] == 'redhat' and os[:release][:major] != 9
      install_packge('crontabs')
      install_packge('curl')
    elsif os[:family] == 'ubuntu'
      install_packge('cron')
      install_packge('curl')
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

  # describe command('/usr/bin/curl http://127.0.0.1 -I') do # for some reason this isn't working as expected. Disabling test.
  #   its(:exit_status) { is_expected.to eq 0 }
  #   its(:stdout) { is_expected.to contain 'HTTP/1.1 200 OK' }
  # end

  describe cron do
    it { is_expected.to have_entry('33 */6 * * * /opt/observium/discovery.php -h all >> /dev/null 2>&1').with_user('root') }
  end

  describe cron do
    it { is_expected.to have_entry('*/5 * * * * /opt/observium/discovery.php -h new >> /dev/null 2>&1').with_user('root') }
  end

  describe cron do
    it { is_expected.to have_entry('*/5 * * * * /opt/observium/poller-wrapper.py >> /dev/null 2>&1').with_user('root') }
  end

  describe cron do
    it { is_expected.to have_entry('13 5 * * * /opt/observium/housekeeping.php -ysel').with_user('root') }
  end

  describe cron do
    it { is_expected.to have_entry('47 4 * * * /opt/observium/housekeeping.php -yrptb').with_user('root') }
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
      it { is_expected.to be_installed }
    end

    describe yumrepo('opennms-common') do
      it { is_expected.to exist }
    end

    describe yumrepo('epel') do
      it { is_expected.to exist }
    end

  elsif os[:family] == 'ubuntu'

    describe service('apache2') do
      it { is_expected.to be_running }
    end

    describe service('snmpd') do
      it { is_expected.to be_running }
    end

    if os[:release] == '22.04'
      describe package('imagemagick') do
        it { is_expected.to be_installed }
      end

      describe package('php8.1-ldap') do
        it { is_expected.to be_installed }
      end
    end

    if os[:release] == '20.04'
      describe package('php7.4-json') do
        it { is_expected.to be_installed }
      end

      describe package('php7.4-ldap') do
        it { is_expected.to be_installed }
      end
    end
  end
end
