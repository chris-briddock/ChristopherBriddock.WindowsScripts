Param([string]$VMName,
      [string]$VMPath,
      $NewVHDSizeBytes = 30GB,
      $MemoryStartupBytes = 3GB,
      [string]$ParentDiskPath,
      [string]$DifferencingDiskPath,
      [string]$VirtualSwitchName,
      $ProcessorCount = 2,
      [bool]$WhatIf = $true)

Import-Module Hyper-V

if ($WhatIf) {
    # Create a new VHD
    New-VHD -Path $DifferencingDiskPath -Differencing -ParentPath $ParentDiskPath -WhatIf

    # Creates a new VM
    New-VM -Name $VMName -Path $VMPath -Generation 2 -VHDPath $DifferencingDiskPath

    # Enable Dynamic Memory allocations
    Set-VMMemory -VMName $VMName -StartupBytes $MemoryStartupBytes -DynamicMemoryEnabled $true -WhatIf

    # Set Processor Cores
    Set-VMProcessor -VMName $VMName -Count $ProcessorCount -WhatIf

    # Add network adapter to VM
    Add-VMNetworkAdapter -VMName $VMName -SwitchName $VirtualSwitchName -NumaAwarePlacement $true -WhatIf

    # Start the VM
    Start-VM -Name $VMName -WhatIf

    # Remove the VM
    Remove-VM -Name $VMName -Confirm:$false -Force -Passthru
}

if ($WhatIf -eq $false) {
    # Create a new VHD
    if (!(Test-Path $DifferencingDiskPath)) {
        New-VHD -Path $DifferencingDiskPath -Differencing -ParentPath $ParentDiskPath
    }
    
    # Creates a new VM
    New-VM -Name $VMName -Path $VMPath -Generation 2 -VHDPath $DifferencingDiskPath

    # Enable Dynamic Memory allocations
    Set-VMMemory -VMName $VMName -StartupBytes $MemoryStartupBytes -DynamicMemoryEnabled $true

    # Set Processor Cores
    Set-VMProcessor -VMName $VMName -Count $ProcessorCount

    # Add network adapter to VM
    Add-VMNetworkAdapter -VMName $VMName -SwitchName $VirtualSwitchName -NumaAwarePlacement $true

    # Start the VM
    Start-VM -Name $VMName
}
