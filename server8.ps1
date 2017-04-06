#NETWORK
Rename-NetAdapter -Name "Ethernet 2" -NewName "LAN"
New-NetIPAddress -InterfaceAlias "LAN" -IPAddress 172.16.24.2 -PrefixLength 21
Set-DnsClientServerAddress -InterfaceAlias "LAN" -ServerAddresses 127.0.0.1


## Installa AD + DC
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "tskoli.win3b" -InstallDns -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "pass.123" -Force)
