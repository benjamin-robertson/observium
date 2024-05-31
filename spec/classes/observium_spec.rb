# frozen_string_literal: true

require 'spec_helper'

describe 'observium' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      if :operatingsystem == 'RedHat' 
        it { is_expected.to contain_service('httpd') }
      elsif :operatingsystem == 'Ubuntu'
        it { is_expected.to contain_service('apache2') }
      end
    end
  end
end
