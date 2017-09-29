param (
[string]$first = (Read-Host 'First name of user'),
[string]$last = (Read-Host 'Last name of user'),
[string]$department = (Read-Host 'department of user'),
[string]$phone = (Read-Host 'phone number of user'),
[string]$manager = (Read-Host 'Username of manager (Not first or last name)')
)

$username = $last + $first.Substring(0,1)
$doesuserexist =get-aduser -Filter * | Where-Object {$_.samaccountname -eq $username}

$managerusername = get-aduser -Filter * | Where-Object {$_.samaccountname -eq $manager}


$password = 'Pa$$word' + (Get-Random -Minimum 100 -Maximum 999)
$passwordsecure = $password | ConvertTo-SecureString -AsPlainText -Force
if ($doesuserexist -ne $null){
  Write-Host 'The user already exists'
  break
} 


if ($managerusername -eq $null){
  Write-Host 'The Managers username is incorrect'
  break
} 

$ADname = $first + ' ' + $last

New-ADUser -SamAccountName $username -name $ADname -GivenName $first -Surname $last -Path 'OU=Users_OU,DC=Adatum,DC=COM' -OfficePhone $phone -Manager $managerusername -Department $department -AccountPassword $passwordsecure 



Get-ADGroup -Filter * | Where-Object {$_.name -eq 'bne.mgt.dataroot'} | Add-ADGroupMember -Members (get-aduser -Filter * | Where-Object {$_.samaccountname -eq $username})