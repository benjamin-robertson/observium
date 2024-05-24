# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'Installation', if: ['centos', 'redhat', 'ubuntu'].include?(os[:family]) do
    before(:all) do
      install_packge('crontabs')
    end

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