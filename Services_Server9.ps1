#Viktor og Einar
#

Rename-NetAdapter -Name "LANTSKOLI" -NewName "LANTSKOLIWIN3B"
New-NetIPAddress -InterfaceAlias LANTSKOLIWIN3B -IPAddress 172.16.24.1 -PrefixLength 21 -DefaultGateway 172.16.24.2
Set-DnsClientServerAddress -InterfaceAlias LANTSKOLIWIN3B -ServerAddresses 172.16.24.2

Install-ADDSForest –DomainName .local –InstallDNS -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "pass.123" -Force)

Install-WindowsFeature –Name DHCP –IncludeManagementTools
Add-DhcpServerv4Scope -Name TskoliScope -StartRange  172.16.25.191 -EndRange 172.16.31.254 -SubnetMask 255.255.248.0
Set-DhcpServerv4OptionValue -DnsServer 172.16.24.2 -Router 172.16.24.2
#Remove-DhcpServerInDC -DnsName WIN3B-08.ViktorH1.local
Add-DhcpServerInDC -DnsName tskoli.win3b #t.d. $($env:computername + “.” $env:userdnsdomain)

#Add-Computer -ComputerName win3b-w81-08 -LocalCredential win3b-w81-08\Administrator -DomainName ViktorH1.local -Credential ViktorH1.local\Administrator -Restart -Force 
#PS C:\Users\Administrator\Documents> Invoke-Command -ComputerName win3b-w81-08 -ScriptBlock { ipconfig /renew }
