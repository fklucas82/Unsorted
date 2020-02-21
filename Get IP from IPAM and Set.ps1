#Rough Idea of Usage:  SetNextIP -VLAN x -Subnet xxx.xxx.xxx.0 -CIDR 24

#Connect to Solarwinds
#Get VLAN and Subnet from User
#Get Next IP in Subnet
#Test that the IP is not in use
    #If the IP responds to ping it must be in use and undocumented in IPAM
    #Update the status of that IP in IPAM and alert
    #Get Next IP and re-test
#
#If IP is good use it
#Connect to vCenter
#Set the VLAN on the NIC
#Set the IP
#Set other IP settings (Subnet Mask, Gateway, DNS)
#Update the status in IPAM

$creds = Get-Credential #For now prompts for credentials, possibly set to a service account later
$swis = Connect-Swis -Hostname solarwinds.hy-vee.net -Credential $creds #Establish connection to Solarwinds Information Service

Invoke-SwisVerb $swis IPAM.SubnetManagement GetFirstAvailableIp @("10.200.87.0", "24")