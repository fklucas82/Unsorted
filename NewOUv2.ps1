#Usage: NewOU.ps1 -Server example -OUPath "OU=File Shares,OU=Security Groups,OU=Corporate,OU=HyVee,DC=Hy-Vee,DC=net" -username admin -password password

param(
$Server, 
$OUPath,
$username,
$password
)

$password=$password|ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($username,$password)

#Set OU
$OU = "OU=" + $Server + "," + $OUPath
$OUCheck = "AD:\$OU"
$OUExists = Test-Path $OUCheck 
If(!$OUExists)
{
New-ADOrganizationalUnit -Name $Server -Path $OUPath -Credential $Credential
}