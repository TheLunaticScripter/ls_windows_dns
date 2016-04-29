#
# Cookbook Name:: ls_windows_dns
# Recipe:: client
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Configure DNS Search server

powershell_script 'Set-DnsClientServerAddress' do
  code <<-EOH
    $CorrectDNSServers = #{node['ls_windows_dns']['dns_servers']}
    $adapter = Get-NetAdapter | where {$_.Status -eq "Up"}
    $adapter | Set-DnsClientServerAddress -ServerAddresses $CorrectDNSServers
  EOH
  guard_interpreter :powershell_script
  not_if <<-EOH
    try{
        $NIC = Get-NetAdapter | where {$_.Status -eq "Up"}
        $dnsServers = $NIC | Get-DnsClientServerAddress -AddressFamily IPv4
        $CorrectDNSServers = #{node['ls_windows_dns']['dns_servers']}
    }
    catch{}
    (Compare-Object $dnsServers.ServerAddresses $CorrectDNSServers -sync 0).Length -eq 0
  EOH
end