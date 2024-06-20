# frozen_string_literal: true

require 'spec_helper'

describe 'observium' do
  let(:hiera_config) { 'hiera-rpsec.yaml' }
  
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it { is_expected.to contain_cron('discovery all devices').with_command('/opt/observium/discovery.php -h all >> /dev/null 2>&1').with_user('root') }
      it { is_expected.to contain_cron('discovery newly added devices').with_command('/opt/observium/discovery.php -h new >> /dev/null 2>&1').with_user('root') }
      it { is_expected.to contain_cron('multithreaded pooler wrapper').with_command('/opt/observium/poller-wrapper.py >> /dev/null 2>&1').with_user('root') }
      it { is_expected.to contain_cron('daily housekeeping for syslog, eventlog and alert log').with_command('/opt/observium/housekeeping.php -ysel').with_user('root') }
      it { is_expected.to contain_cron('housekeeping script daily for rrds, ports, orphaned entries in the database and performance data').with_user('root') }

      it { is_expected.to contain_snmp__snmpv3_user('observium') }
      it { is_expected.to contain_mysql__db('observium') }

      it { is_expected.to contain_package('rrdtool') }

      it { is_expected.to contain_file('/opt/observium').with_ensure('directory') }
      it { is_expected.to contain_file('/opt/observium/rrd').with_ensure('directory') }
      it { is_expected.to contain_file('/opt/observium/config.php').with_ensure('file') }

      it { is_expected.to contain_archive('observium-community-latest.tar.gz') }

      it { is_expected.to contain_exec('Create TLS cert').with_refreshonly(true) }
    end
  end

  context 'on rhel7' do
    let(:facts) do
      {
        'os' => {
          'family' => 'RedHat',
          'name'   => 'RedHat',
          'release' => {
            'major' => '7',
          },
          'selinux' => {
            'enabled' => true,
            'current_mode' => 'enforcing',
          },
        }
      }
    end

    it { is_expected.to contain_service('httpd') }
  end

  context 'on rhel8' do
    let(:facts) do
      {
        'os' => {
          'family' => 'RedHat',
          'name'   => 'RedHat',
          'release' => {
            'major' => '8',
          },
          'selinux' => {
            'enabled' => true,
            'current_mode' => 'enforcing',
          },
        }
      }
    end

    it { is_expected.to contain_service('httpd') }
    it { is_expected.to contain_package('python3-PyMySQL') }
    it { is_expected.to contain_package('php-json') }
  end

  context 'on rhel9' do
    let(:facts) do
      {
        'os' => {
          'family' => 'RedHat',
          'name'   => 'RedHat',
          'release' => {
            'major' => '9',
          },
          'selinux' => {
            'enabled' => true,
            'current_mode' => 'enforcing',
          },
        }
      }
    end

    it { is_expected.to contain_service('httpd') }
    it { is_expected.to contain_package('python3-PyMySQL') }
    it { is_expected.to contain_package('php-json') }
  end

  context 'on ubuntu 18.04' do
    let(:facts) do
      {
        'os' => {
          'family' => 'Debian',
          'name'   => 'Debian',
          'release' => {
            'major' => '18.04',
            'full'  => '18.04',
          },
          'selinux' => {
            'enabled' => true,
            'current_mode' => 'enforcing',
          },
        }
      }
    end

    # it { is_expected.to contain_service('apache2') }
    it { is_expected.to contain_package('php-pear') }
    it { is_expected.to contain_package('php7.2-mysql') }
  end

  context 'on ubuntu 20.04' do
    let(:facts) do
      {
        'os' => {
          'family' => 'Debian',
          'name'   => 'Debian',
          'release' => {
            'major' => '20.04',
            'full'  => '20.04',
          },
          'selinux' => {
            'enabled' => true,
            'current_mode' => 'enforcing',
          },
        }
      }
    end

    # it { is_expected.to contain_service('apache2') }
    it { is_expected.to contain_package('php7.4-ldap') }
    it { is_expected.to contain_package('php7.4-json') }
  end

  context 'on ubuntu 22.04' do
    let(:facts) do
      {
        'os' => {
          'family' => 'Debian',
          'name'   => 'Debian',
          'release' => {
            'major' => '22.04',
            'full'  => '22.04',
          },
          'selinux' => {
            'enabled' => true,
            'current_mode' => 'enforcing',
          },
        }
      }
    end

    # it { is_expected.to contain_service('apache2') }
    it { is_expected.to contain_package('php8.1-ldap') }
    it { is_expected.to contain_package('imagemagick') }
  end
end
