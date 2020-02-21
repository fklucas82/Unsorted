Connect-VIServer -Server corpvcenter-v.hy-vee.net -Force



$TestHost = Get-ESXCli -VMHost corpesxhost1-h.hy-vee.net

$testhost.system.module.parameters.list("iscsi_vmk") | Where {$_.Name -eq "iscsivmk_LunQDepth"}