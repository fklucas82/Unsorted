Connect-VIServer -Server corpvcenter-v.hy-vee.net -Force
Get-VMHost | Get-VMHostNetwork | Select Hostname, VMkernelGateway -ExpandProperty VirtualNic |  Select Hostname, PortGroupName, IP | Where {$_.PortGroupName -like "iSCSI*"}
