Param(
    [string]$InterfaceAlias,
    [string]$ServerHostname, 
    [string]$ServerIPAddress)

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module PSWindowsUpdate -Confirm:$false 

Get-WindowsUpdate -Force

Install-WindowsUpdate -Confirm:$false -Force

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Tools-All -All

Set-NetConnectionProfile -InterfaceAlias $InterfaceAlias -NetworkCategory Private

Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value "`n$ServerIPAddress`t$ServerHostname"

winrm quickconfig -q

Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$ServerHostname" -Confirm:$false

Enable-WSManCredSSP -Role client -DelegateComputer "$ServerHostname" -Confirm:$false

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\" -Name 'CredentialsDelegation'
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\" -Name 'AllowFreshCredentialsWhenNTLMOnly' -PropertyType DWord -Value "00000001"
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\" -Name 'ConcatenateDefaults_AllowFreshNTLMOnly' -PropertyType DWord -Value "00000001"
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\" -Name 'AllowFreshCredentialsWhenNTLMOnly'
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowFreshCredentialsWhenNTLMOnly\" -Name '1' -Value "wsman/$ServerHostname"

