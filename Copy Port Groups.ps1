Connect-VIServer -Server corpvcenter-v.hy-vee.net -Force

$sourcehost = "corpdevhost3-h.hy-vee.net"
$sourceVswitch = Get-VirtualSwitch -VMHost $sourcehost -Name "vSwitch0"
$sourcePortGroups = Get-VirtualPortGroup -VirtualSwitch $sourceVswitch

$desthost = "corpdevhost4-h.hy-vee.net"

$hostcred = Get-Credential

Connect-VIServer -Server $desthost -Credential $hostcred
$destVswitch = Get-VirtualSwitch -VMHost $desthost -Name "vSwitch0"

ForEach ($sourcePortGroup in $sourcePortGroups)
{
    If ($sourcePortGroup.VLanId -ne 0)
    {
        New-VirtualPortGroup -Name $sourcePortGroup.Name -VirtualSwitch $destVswitch -VLanId $sourcePortGroup.VLanId
    }
}




