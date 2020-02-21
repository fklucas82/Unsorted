Connect-VIServer -Server corpvcenter-v.hy-vee.net -Force


$CorpESXHosts = Get-VMHost | Where {$_.Name -like "corpdev*"} | Sort Name
Foreach ($esxhost in $CorpESXHosts) {
    Get-VMhost $esxhost | Get-ScsiLun -LunType disk | Where { $_.MultipathPolicy -notlike "RoundRobin" } | Set-Scsilun -MultiPathPolicy RoundRobin
}