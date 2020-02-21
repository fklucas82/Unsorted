<#
    .SYNOPSIS
        Creates a new VM within vCenter, attaches a specified ISO and boots it in preparation to become a template
    .PARAMETER Name
        The name of the template
    
    .PARAMETER Credential
        The credentials used to connect to vCenter
    .EXAMPLE
        C:\PS> .\New-VMTemplate.ps1 -Name "Template_Server2016" -Credential (Get-Credential)
#>

#Define params
param
(
    [Parameter(Mandatory=$true)]
    [string]
    $Name,
    [Parameter(Mandatory=$false)]
    [PSCredential]
    $Credential = (Get-Credential)
)

#Import modules if they have not been imported yet
if($null -eq (Get-Module VMware.PowerCLI))
{
    Import-Module VMware.PowerCLI
}

#Since we are not using a valid cert in vCenter, set PowerCLI config to ignore SSL warnings/errors
Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore -Scope User -ProxyPolicy NoProxy -Confirm:$false

#These variables will change depending on OS being deployed, and other settings
$iso_image_path = "[pure-wdm-ds0] ISOs/SW_DVD9_Win_Server_STD_CORE_2019_64Bit_English_DC_STD_MLF_X21-96581.ISO"
$vmware_tools_path = "[pure-wdm-ds0] ISOs/VMware-tools-windows-10.3.5-10430147.iso"

#Set some variables to use throughout script
$vcenter_server = "corpvcenter-v.hy-vee.net"  #vCenter server to connect to
$folder = "Template"  #Folder the template will be stored in
$memory = "8192"  #memory for template
$cpu = "2"  #CPU count for template
$cluster_name = "WDMApps-Cluster"  #Set the cluster name
$datastore_filter = "pure-wdm-ds*"  #Pointing it to FlashStack array

#Connect to vCenter
$vc_connection = Connect-VIServer -Server $vcenter_server -Credential $Credential

$cluster = Get-Cluster $cluster_name  #Get the cluster name

#Get random datastore
$datastore = $cluster | Get-Datastore | Where-Object {$_.Name -like $datastore_filter} | Get-Random

#Create the VM in vSphere
New-VM -Name $Name -ResourcePool $cluster -Location $folder -Version v13 -NumCpu $cpu -MemoryMB $memory -DiskStorageFormat Thin -DiskGB 60 -Datastore $datastore -GuestId windows9Server64Guest -Confirm:$false

#Set SCSI controller to Paravirtual
Get-ScsiController -VM $name | Set-ScsiController -Type ParaVirtual -Confirm:$false

#Add a CD drive to mount Windows Install ISO to and grab the PVSCSI driver during install
New-CDDrive -IsoPath $iso_image_path -StartConnected:$true -VM $Name -Confirm:$false

#Add a CD drive to mount VMware Tools to and grab the PVSCSI driver during install
New-CDDrive -IsoPath $vmware_tools_path -StartConnected:$true -VM $Name -Confirm:$false

#Set Network Adapter Type to VMXNet3 and VLAN 215
Get-VM $Name | Get-NetworkAdapter | Set-NetworkAdapter -Type VMXNet3 -NetworkName "DS_WDMApps_215" -Confirm:$False

#start the VM
Start-VM -VM $Name -Confirm:$false

#Clean things up at the end

Disconnect-VIServer $vc_connection -Confirm:$false
Set-PowerCLIConfiguration -InvalidCertificateAction:Unset -Scope User -Confirm:$false