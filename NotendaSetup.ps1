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
     #$htable.Clear()
$htable = @{}
$htable.Add("á","a")
$htable.Add("é","e")
$htable.Add("ó","o")
$htable.Add("ý","y")
$htable.Add("í","i")
$htable.Add("ð","d")
$htable.Add("þ","t")
$htable.Add("ö","o")
$htable.Add("ú","u")
$htable.Add("æ","a")

    $firstname = $nafn.Split(" ")[0]
    $middlename = $nafn.Split(" ")[1]
    $lastName = $nafn.Split(" ")[2]
    $lasterName = $nafn.Split(" ")[3]
    if(!$lastName){
        $username = $firstname.Substring(0,2)+$middlename.Substring(0,1)
    }#end if statement
    elseif($lasterName){
        $username = $firstname.Substring(0,2)+$lasterName.Substring(0,1)
    }#end elseif statement
    else{
        $username = $firstname.Substring(0,2)+$lastName.Substring(0,1)
    }#end else statement
    $username = $username.ToLower()
            $Notendanafn = ""
    foreach($stafur in $username.ToCharArray()) {
        if($htable.Contains($stafur.tostring())) {
            $Notendanafn += $htable[$stafur.tostring()]
        }#end if statement
        else {
            $Notendanafn += $stafur.tostring()
        }#end else statement
    }#end foreach statement

    $usercounter = (Get-ADUser -Filter * -SearchBase $("OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=local") -Filter {name -eq $Notandanafn}).Count       
     while ($usercounter -gt 0) {
        $Notendanafn = $Notendanafn + 1.toString()
     }
}
