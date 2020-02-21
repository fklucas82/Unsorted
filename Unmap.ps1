#Import Module, Set to Ignore Self Signed Cert, Connect to vCenter
Import-Module VMware.PowerCLI
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Connect-VIServer -Server corpvcenter-v.hy-vee.net


#Gather all Corporate Clusters into an Array
$Clusters = Get-Cluster -Location "Corporate" | Where {$_.Name -like "Corp*"}

#Loop through Each CLuster
ForEach ( $Cluster in $Clusters)
{
    #Report Current Cluster
    $Cluster.Name
    #Gather all Hosts in this cluster into an Array
    $Hosts = Vmware.VimAutomation.Core\Get-VMHost -Location $Cluster.Name

    #Gather all Datastores on a random host in the cluster into an Array
    $HostNumber = Get-Random -Maximum ($Hosts.count - 1) 	
    $Datastores = Get-Datastore -VMHost $Hosts[$HostNumber] #| Where {$_.Name -like "Veeam*"}

    #Loop through each datastore
    ForEach ($Datastore in $Datastores)
    {
    #Select A Random Host to Run the Unmap Command
    $HostNumber = Get-Random -Maximum ($Hosts.count - 1)
    $esxName = $Hosts[$HostNumber]

    #Report Current Host and Datastore
    $esxName.Name
    $Datastore.Name

    #Create array of ESXCLI commands to run the unmap command from
    $esxcli = Get-EsxCli -VMHost $esxName -V2

    #Set the parameters used for the unmap command
    $sParam = @{
    reclaimunit = 100
    volumelabel = $Datastore

    }

    #Run the unmap command
    $esxcli.storage.vmfs.unmap.Invoke($sParam)

    }
}

