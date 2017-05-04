cd C:\Users\Administrator\Documents
$notendur = Import-Csv -Path "lokaverk_notendur_u.csv"

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

$Allir = @()
foreach($n in $notendur){
    $skoli = $n.'Skóli;Deild;Nafn'.Split(";")[0]
    $deild = $n.'Skóli;Deild;Nafn'.Split(";")[1]
    $nafn = $n.'Skóli;Deild;Nafn'.Split(";")[2]

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
    $temp = ""
    foreach($stafur in $username.ToCharArray()) {
        if($htable.Contains($stafur.tostring())) {
            $Notendanafn += $htable[$stafur.tostring()]
            $temp += $htable[$stafur.tostring()]
        }#end if statement
        else {
            $Notendanafn += $stafur.tostring()
            $temp += $stafur.tostring()
        }#end else statement
    }#end foreach statement

    $counter = 0
    while ($Allir -contains $Notendanafn) {
        $counter += 1
        $Notendanafn = $temp + $counter
    }
    $Allir += $Notendanafn
    $Notendanafn

    if ($deild.Length -gt 0) {
        New-ADUSer -Name $nafn -DisplayName $nafn -Department $deild -SamAccountName $Notendanafn -UserPrincipalName $($Notendanafn+"@tskoli.win3b") -Path $("OU="+$deild+",OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=win3b") -AccountPassword(ConvertTo-SecureString -AsPlainText "zxyq.123" -Force) -Enabled $true
    } else {
        New-ADUSer -Name $nafn -DisplayName $nafn -Department $deild -SamAccountName $Notendanafn -UserPrincipalName $($Notendanafn+"@tskoli.win3b") -Path $("OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=win3b") -AccountPassword(ConvertTo-SecureString -AsPlainText "zxyq.123" -Force) -Enabled $true
    }
    

}#end overall foreach statement
