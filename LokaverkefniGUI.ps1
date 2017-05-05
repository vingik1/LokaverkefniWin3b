[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

function CreateUser {
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

    $skoli = $CboxSkoli.SelectedItem.ToString()
    $deild = $CboxDeild.SelectedItem.ToString()
    $nafn = $TxtName.Text

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
    $check = Get-ADUser -Filter { SamAccountName -eq $Notendanafn }
    while ($check -ne $null) {
        $counter += 1
        $Notendanafn = $temp + $counter
        $check = Get-ADUser -Filter { SamAccountName -eq $Notendanafn }
    }

    if ($deild.Length -gt 0) {
        New-ADUSer -Name $nafn -DisplayName $nafn -Department $deild -SamAccountName $Notendanafn -UserPrincipalName $($Notendanafn+"@tskoli.win3b") -Path $("OU="+$deild+",OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=win3b") -AccountPassword(ConvertTo-SecureString -AsPlainText "zxyq.123" -Force) -Enabled $true
    } else {
        New-ADUSer -Name $nafn -DisplayName $nafn -Department $deild -SamAccountName $Notendanafn -UserPrincipalName $($Notendanafn+"@tskoli.win3b") -Path $("OU="+$skoli+",OU=WIN3B_Tskoli,DC=tskoli,DC=win3b") -AccountPassword(ConvertTo-SecureString -AsPlainText "zxyq.123" -Force) -Enabled $true
    }

    $LblCreated.Text =  "User " + $nafn + " Created in " + $skoli + " - " + $deild
}

# Næ í alla Skóla sem eru til
$Skolar = @()
$OU = 'ou=WIN3B_Tskoli,dc=tskoli,dc=win3b'
$Skolar += (Get-ADOrganizationalUnit -SearchBase $OU -SearchScope OneLevel -Filter *).Name

# Bý til formin
$Window = New-Object System.Windows.Forms.Form
$LblName = New-Object System.Windows.Forms.Label
$LblSkoli = New-Object System.Windows.Forms.Label
$LblDeild = New-Object System.Windows.Forms.Label
$BtnCreate = New-Object System.Windows.Forms.Button
$CboxSkoli = New-Object System.Windows.Forms.ComboBox
$CboxDeild = New-Object System.Windows.Forms.ComboBox
$TxtName = New-Object System.Windows.Forms.TextBox


# Aðal glugginn
$Window.ClientSize = New-Object System.Drawing.Size(350, 350)
$Window.Text = "Powershell GUI"

# Nafn Label
$LblName.Location = New-Object System.Drawing.Point(30,30)
$LblName.Size = New-Object System.Drawing.Size(50,20)
$LblName.Text = "Nafn:"

# Skoli Label
$LblSkoli.Location = New-Object System.Drawing.Point(30,100)
$LblSkoli.Size = New-Object System.Drawing.Size(50,20)
$LblSkoli.Text = "Skóli:"

# Deild Label
$LblDeild.Location = New-Object System.Drawing.Point(30, 170)
$LblDeild.Size = New-Object System.Drawing.Size(50, 20)
$LblDeild.Text = "Deild:"

# Skrá Notanda Takki
$BtnCreate.Location = New-Object System.Drawing.Point(110, 240)
$BtnCreate.Size = New-Object System.Drawing.Size(130, 30)
$BtnCreate.Text = "Skrá Notanda"
$BtnCreate.add_click( { CreateUser } )

# Skoli Checkbox
$CboxSkoli.Location = New-Object System.Drawing.Point(80, 100)
$CboxSkoli.Size = New-Object System.Drawing.Size(210, 30)

# Deild Checkbox
$CboxDeild.Location = New-Object System.Drawing.Point(80, 170)
$CboxDeild.Size = New-Object System.Drawing.Size(210,30)

# Nafn Textbox
$TxtName.Location = New-Object System.Drawing.Point(80,30)
$TxtName.Size = New-Object System.Drawing.Size(210,30)

# Set Items í Comboboxin
$CboxSkoli.Items.AddRange($Skolar)

$CboxSkoli_SelectedIndexChanged = {
$CboxDeild.Items.Clear()
if ($CboxSkoli.SelectedIndex -gt -1) {
    $Deildir = @()
    $ThisOU = 'ou=' + $CboxSkoli.SelectedItem.ToString() + ',ou=WIN3B_Tskoli,dc=tskoli,dc=win3b'
    $Deildir = (Get-ADOrganizationalUnit -SearchBase $ThisOU -SearchScope OneLevel -Filter *).Name
}
$CboxDeild.Items.AddRange($Deildir)

$CboxDeild.SelectedIndex = 0
}

$CboxSkoli.add_SelectedIndexChanged($CboxSkoli_SelectedIndexChanged)

$Window.Controls.Add($LblName)
$Window.Controls.Add($LblSkoli)
$Window.Controls.Add($LblDeild)
$Window.Controls.Add($CboxSkoli)
$Window.Controls.Add($CboxDeild)
$Window.Controls.Add($TxtName)
$Window.Controls.Add($BtnCreate)

$LblCreated = New-Object System.Windows.Forms.Label
$LblCreated.Location = New-Object System.Drawing.Point(10, 280)
$LblCreated.Size = New-Object System.Drawing.Size(340, 130)
$Window.Controls.Add($LblCreated)

$Window.ShowDialog()
