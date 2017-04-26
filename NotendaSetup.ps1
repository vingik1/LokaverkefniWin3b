cd C:\Users\Administrator\Documents
$notendur = Import-Csv -Path "lokaverk_notendur_u.csv"

New-ADOrganizationalUnit -name WIN3B_Tskoli -ProtectedFromAccidentalDeletion $false
New-ADGroup -name AllirTskoli -Path "OU=WIN3B_Tskoli,DC=tskoli,DC=local" -GroupScope Global
foreach($n in $notendur){
    $skoli = $n.'Skóli;Deild;Nafn'.Split(";")[0]
    $deild = $n.'Skóli;Deild;Nafn'.Split(";")[1]
    $nafn = $n.'Skóli;Deild;Nafn'.Split(";")[2]

    if((Get-ADOrganizationalUnit -Filter {name -eq $skoli }).Name -ne $skoli) {

        New-ADOrganizationalUnit -name $skoli -Path "OU=WIN3B_Tskoli,DC=tskoli,DC=local" -ProtectedFromAccidentalDeletion $false
        New-ADGroup -Name $skoli -Path $("OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=local") -GroupScope Global
        Add-ADGroupMember -Identity AllirTskoli -Members $skoli
        }
        
}

foreach($n in $notendur){
            $skoli = $n.'Skóli;Deild;Nafn'.Split(";")[0]
    $deild = $n.'Skóli;Deild;Nafn'.Split(";")[1]
    $nafn = $n.'Skóli;Deild;Nafn'.Split(";")[2]
    if((Get-ADOrganizationalUnit -SearchBase $("OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=local") -Filter {name -eq $deild }).Name -ne $deild) {

        New-ADOrganizationalUnit -name $deild -Path $("OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=local") -ProtectedFromAccidentalDeletion $false
        New-ADGroup -Name $deild -Path $("OU="+$deild+",OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=local") -GroupScope Global
        }
}