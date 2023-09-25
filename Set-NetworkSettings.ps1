Param (
    [string]$InterfaceName = "Ethernet",
    [string]$IPAddress = "192.168.1.197",
    [string]$SubnetMask = "255.255.255.0",
    [string]$DefaultGateway = "192.168.1.1",
    [string]$DNSServers = "192.168.1.254",
    [string]$Hostname
)

# Disable DHCP and set the static IP address, subnet mask, and default gateway
Set-NetIPInterface -InterfaceAlias $InterfaceName -AddressFamily IPv4 -Dhcp Disabled
New-NetIPAddress -InterfaceAlias $InterfaceName -IPAddress $IPAddress -PrefixLength 24 -DefaultGateway $DefaultGateway

# Set DNS server addresses
Set-DnsClientServerAddress -InterfaceAlias $InterfaceName -ServerAddresses $DNSServers

# Verify the changes
Write-Host "Network settings configured:"
Get-NetIPAddress | Format-Table -AutoSize
Get-DnsClientServerAddress

# Optional: Restart the network adapter (uncomment if needed)
Restart-NetAdapter -InterfaceAlias $InterfaceName

Rename-Computer $Hostname

Write-Host "Network settings have been applied successfully."