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
