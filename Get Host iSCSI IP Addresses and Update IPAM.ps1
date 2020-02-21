#Get IP addresses of iSCSI interfaces from vSphere Hosts
#Update the status of those IP addresses in IPAM

#Connect to vCenter
Connect-VIServer -Server corpvcenter-v.hy-vee.net -Force
#Get iSCSI IP Addresses
$iSCSI_IPs = Get-VMHost | Get-VMHostNetwork | Select Hostname, VMkernelGateway -ExpandProperty VirtualNic |  Select Hostname, PortGroupName, IP | Where {$_.PortGroupName -like "iSCSI*"}

#Connect to IPAM
#Recursively set status of each IP address in IPAM