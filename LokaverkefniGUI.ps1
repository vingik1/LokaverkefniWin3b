#Viktor Ingi Kárason
#Win3b
#5.3.2017


#Hleð inn klösum fyrir GUI, svipað og References í C#
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

#Breytan notendur er hashtafla sem heldur utan um alla notendur sem finnast, 
#breytan þarf að vera "global" innan skriptunnar
$Script:notendur = @{} 
#Fall sem sér um að búa til Vefsidu Notenda

#Fall sem sér um að búa til notendur
function BuaTilNotenda  {
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
    $nafn = $txtNafn.Text
    $deild = $DropBox.Text

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

    New-ADUser -Name $nafn -DisplayName $nafn -GivenName $firstname -Surname $lastName -Department $deild -SamAccountName $Notendanafn -EmailAddress $($Notendanafn+"@tskoli.is") -UserPrincipalName $($Notendanafn+"@tskoli.local") -Path $("OU="+$deild+",OU=BBP,DC=bbp-ViktorH1,DC=local") -AccountPassword(ConvertTo-SecureString -AsPlainText "pass.123" -Force) -Enabled $true
    Add-ADGroupMember -Identity $deild -Members $newUsername

}

#Aðalglugginn 
#Bý til tilvik af Form úr Windows Forms
$frmLeita = New-Object System.Windows.Forms.Form
#Set stærðina á forminu
$frmLeita.ClientSize = New-Object System.Drawing.Size(400,200)
#Set titil á formið
$frmLeita.Text = "Powershell GUI"

#Leita takkinn
#Bý til tilvik af Button
$btnBuaTilNot = New-Object System.Windows.Forms.Button
#Set staðsetningu á takkanum
$btnBuaTilNot.Location = New-Object System.Drawing.Point(300,36)
#Set stærðina á takkanum
$btnBuaTilNot.Size = New-Object System.Drawing.Size(75,40)
#Set texta á takkann
$btnBuaTilNot.Text = "Búa til notenda"
#Bý til event sem keyrir þegar smellt er á takkann. Þegar smellt er á takkan á að kalla í fallið LeitaAdNotendum
$btnBuaTilNot.add_Click({ BuaTilNotenda})
#Sett takkann á formið
$frmLeita.Controls.Add($btnBuaTilNot)

#Label OUDropbox:
#Bý til tilvik af Label
$lblOU = New-Object System.Windows.Forms.Label
#Set staðsetningu á label-inn
$lblOU.Location = New-Object System.Drawing.Point(35,90)
#Set stærðina
$lblOU.Size = New-Object System.Drawing.Size(30,20)
#Set texta á 
$lblOU.Text = "OU:"
#Set label-inn á formið
$frmLeita.Controls.Add($lblOU)

$DropBox = New-Object System.Windows.Forms.ComboBox
$DropBox.Location = New-Object System.Drawing.Point(80,90)
#set stærðina
$DropBox.Size = New-Object System.Drawing.Size(200,90)
#set values í combo boxið
$OU = Get-ADOrganizationalUnit -Filter * -SearchBase "OU=BBP,DC=bbp-ViktorH1,DC=local" | select -ExpandProperty name
foreach($deild in $OU){
    $DropBox.Items.Add($deild)
}
#set Dropboxið á form
$frmLeita.Controls.Add($DropBox)

#Label Nafn:
#Bý til tilvik af Label
$lblNafn = New-Object System.Windows.Forms.Label
#Set staðsetningu á label-inn
$lblNafn.Location = New-Object System.Drawing.Point(30,30)
#Set stærðina
$lblNafn.Size = New-Object System.Drawing.Size(50,20)
#Set texta á 
$lblNafn.Text = "Nafn:"
#Set label-inn á formið
$frmLeita.Controls.Add($lblNafn)

#Textabox fyrir Nafn
#Bý til tilvik af TextBox
$txtNafn = New-Object System.Windows.Forms.TextBox
#Set staðsetninguna
$txtNafn.Location = New-Object System.Drawing.Point(80,30)
#Set stærðina
$txtNafn.Size = New-Object System.Drawing.Size(210,30)
#Set textboxið á formið
$frmLeita.Controls.Add($txtNafn)

#Birti formið
$frmLeita.ShowDialog()