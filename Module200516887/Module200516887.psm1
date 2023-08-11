$env:path += ";$home/documents/github/comp2101/powershell"
function Welcome-Message {
    write-output "Welcome to planet $env:computername Overlord $env:username"
    $now = get-date -format 'HH:MM tt on dddd'
    write-output "It is $now."
}

Welcome-Message

    write-output "Welcome to planet $env:computername Overlord $env:username"
    $now = get-date -format 'HH:MM tt on dddd'
    write-output "It is $now."


    write-output "Welcome to planet $env:computername Overlord $env:username"
    $now = get-date -format 'HH:MM tt on dddd'
    write-output "It is $now."

function Get-CpuInfo {
    $processors = Get-CimInstance CIM_Processor
    foreach ($processor in $processors) {
        $props = @{
            Manufacturer = $processor.Manufacturer
            Model = $processor.Name
            CurrentSpeed = "$($processor.CurrentClockSpeed) MHz"
            MaxSpeed = "$($processor.MaxClockSpeed) MHz"
            NumberOfCores = $processor.NumberOfCores
        }
        $obj = New-Object PSObject -Property $props
        $obj | Format-List
    }
}

function Get-MyDisks {
    $disks = Get-CimInstance -ClassName Win32_DiskDrive

    $diskInfo = @()
    foreach ($disk in $disks) {
        $props = @{
            Manufacturer      = $disk.Manufacturer
            Model             = $disk.Model
            SerialNumber      = $disk.SerialNumber
            FirmwareRevision  = $disk.FirmwareRevision
            Size              = "{0} GB" -f [math]::Round($disk.Size / 1GB, 2)
        }

        $obj = New-Object PSObject -Property $props
        $diskInfo += $obj
    }

    $diskInfo | Format-Table -AutoSize
}

function get-ipinfo {
    Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | ForEach-Object {
        $props = @{
            Description   = $_.Description
            Index         = $_.Index
            IPAddress     = $_.IPAddress -join ', '
            SubnetMask    = $_.IPSubnet -join ', '
            DNSDomainName = $_.DNSDomain
            DNSServer     = $_.DNSServerSearchOrder -join ', '
        }

        New-Object PSObject -Property $props
    } | Format-Table -AutoSize
}

function systemreport {
    param (
        [switch]$System,
        [switch]$Disks,
        [switch]$Network
    )

    if (!$System -and !$Disks -and !$Network) {
        $System = $Disks = $Network = $true
    }

    if ($System) {
        Write-Host "CPU Information:"
        Get-CimInstance -ClassName CIM_Processor | Select-Object -Property Manufacturer, Model, MaxClockSpeed, NumberOfCores | Format-Table -AutoSize

        Write-Host "`nOperating System Information:"
        Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property Caption, BuildNumber, Version | Format-Table -AutoSize

        Write-Host "`nRAM Information:"
        Get-CimInstance -ClassName Win32_PhysicalMemory | ForEach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name "Capacity (GB)" -Value ([math]::Round($_.Capacity / 1GB, 2))
            $_ | Add-Member -MemberType NoteProperty -Name "Speed (MHz)" -Value $_.Speed
            $_
        } | Select-Object -Property "Capacity (GB)", "Speed (MHz)" | Format-Table -AutoSize

        Write-Host "`nVideo Information:"
        Get-CimInstance -ClassName Win32_VideoController | Select-Object -Property Name, VideoProcessor, AdapterRAM | ForEach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name "AdapterRAM (GB)" -Value ([math]::Round($_.AdapterRAM / 1GB, 2))
            $_
        } | Select-Object -Property Name, VideoProcessor, "AdapterRAM (GB)" | Format-Table -AutoSize
    }

    if ($Disks) {
        Write-Host "`nDisk Information:"
        Get-CimInstance -ClassName Win32_DiskDrive | Select-Object -Property Manufacturer, Model, SerialNumber, FirmwareRevision, Size | ForEach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name "Size (GB)" -Value ([math]::Round($_.Size / 1GB, 2))
            $_
        } | Select-Object -Property Manufacturer, Model, SerialNumber, FirmwareRevision, "Size (GB)" | Format-Table -AutoSize
    }

    if ($Network) {
        Write-Host "`nNetwork Information:"
        Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | ForEach-Object {
            $props = @{
                Description   = $_.Description
                Index         = $_.Index
                IPAddress     = $_.IPAddress -join ', '
                SubnetMask    = $_.IPSubnet -join ', '
                DNSDomainName = $_.DNSDomain
                DNSServer     = $_.DNSServerSearchOrder -join ', '
            }

            New-Object PSObject -Property $props
        } | Format-Table -AutoSize
    }
}