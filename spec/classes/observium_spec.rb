# frozen_string_literal: true

require 'spec_helper'

describe 'observium' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }


      # it { is_expected.to contain_service('apache2') }
      # it { is_expected.to contain_service(os) }

    end
  end

  context "on rhel7" do
    let(:facts) do
      { 
        'os' => {
          'family' => 'RedHat',
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

  context "on rhel8" do
    let(:facts) do
      { 
        'os' => {
          'family' => 'RedHat',
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
    it { is_expected.to contain_package('python3-PyMySQL')}
    it { is_expected.to contain_package('php-json')}
  end
end
