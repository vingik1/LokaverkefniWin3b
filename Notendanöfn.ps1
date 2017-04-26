cd D:\OneDrive\2017V\WIN3B3U\Lokaverkefni
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
    foreach($stafur in $username.ToCharArray()) {
        if($htable.Contains($stafur.tostring())) {
            $Notendanafn += $htable[$stafur.tostring()]
        }#end if statement
        else {
            $Notendanafn += $stafur.tostring()
        }#end else statement
    }#end foreach statement
    $Notendanafn
}#end overall foreach statement



