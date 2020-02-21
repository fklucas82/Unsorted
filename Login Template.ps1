

#Import modules if they have not been imported yet
if($null -eq (Get-Module VMware.PowerCLI))
{
    Import-Module VMware.PowerCLI
}

#Since we are not using a valid cert in vCenter, set PowerCLI config to ignore SSL warnings/errors
Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore -Scope User -ProxyPolicy NoProxy -Confirm:$false

#Set some variables to use throughout script
$vcenter_server = "corpvcenter-v.hy-vee.net"  #vCenter server to connect to
$Creds = Get-Credential
#Connect to vCenter
$vc_connection = Connect-VIServer -Server $vcenter_server -Credential $Creds

get-vm | select name, Powerstate, @{N="IPAddress"; E={$_.Guest.IPAddress[0]}}, @{N="DnsName"; E={$_.ExtensionData.Guest.Hostname}}




$AllHosts = Get-VMHost

ForEach($Host in $AllHosts)
{
#Stuff
}