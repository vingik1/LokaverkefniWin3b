#NETWORK
Rename-NetAdapter -Name "Ethernet 2" -NewName "LAN"
New-NetIPAddress -InterfaceAlias "LAN" -IPAddress 172.16.24.2 -PrefixLength 21
Set-DnsClientServerAddress -InterfaceAlias "LAN" -ServerAddresses 127.0.0.1


## Installa AD + DC
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "tskoli.win3b" -InstallDns -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "pass.123" -Force)

#bæta við ou skolar og deildir
cd C:\Users\Administrator\Documents
$notendur = Import-Csv -Path "lokaverk_notendur_u.csv"

New-ADOrganizationalUnit -name WIN3B_Tskoli -ProtectedFromAccidentalDeletion $false
New-ADGroup -name AllirTskoli -Path "OU=WIN3B_Tskoli,DC=tskoli,DC=win3b" -GroupScope Global
foreach($n in $notendur){
    $skoli = $n.'Skóli;Deild;Nafn'.Split(";")[0]
    $deild = $n.'Skóli;Deild;Nafn'.Split(";")[1]
    $nafn = $n.'Skóli;Deild;Nafn'.Split(";")[2]

    if((Get-ADOrganizationalUnit -Filter {name -eq $skoli }).Name -ne $skoli) {

        New-ADOrganizationalUnit -name $skoli -Path "OU=WIN3B_Tskoli,DC=tskoli,DC=win3b" -ProtectedFromAccidentalDeletion $false
        New-ADGroup -Name $skoli -Path $("OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=win3b") -GroupScope Global
        Add-ADGroupMember -Identity AllirTskoli -Members $skoli
        }
        
}

foreach($n in $notendur){
            $skoli = $n.'Skóli;Deild;Nafn'.Split(";")[0]
    $deild = $n.'Skóli;Deild;Nafn'.Split(";")[1]
    $nafn = $n.'Skóli;Deild;Nafn'.Split(";")[2]
    if((Get-ADOrganizationalUnit -SearchBase $("OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=win3b") -Filter {name -eq $deild }).Name -ne $deild) {

        New-ADOrganizationalUnit -name $deild -Path $("OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=win3b") -ProtectedFromAccidentalDeletion $false
        New-ADGroup -Name $deild -Path $("OU="+$deild+",OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=win3b") -GroupScope Global
        }
}
