#
# Cookbook Name:: ls_windows_dns
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'ls_windows_dns::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
      runner.converge(described_recipe)
    end

    before do
      stub_command("
          try{
              $NIC = Get-NetAdapter | where {$_.Status -eq \"Up\"}
              $dnsServers = $NIC | Get-DnsClientServerAddress -AddressFamily IPv4
              $CorrectDNSServers = \"\'10.0.0.1\',10.0.0.2\"
          }
          catch{}
          (Compare-Object $dnsServers.ServerAddresses $CorrectDNSServers -sync 0).Length -eq 0").and_return(false)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
