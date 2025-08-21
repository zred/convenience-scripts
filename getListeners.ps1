function Get-Listeners {
    param (
        [string]$ProcessName = "*",
        [int[]]$ProcessIds = @(),
        [int[]]$Ports = @()
    )
    Get-NetTCPConnection -State Listen |
    Where-Object { 
        ($_.OwningProcess -in @(
            Get-Process *$ProcessName* |
            Select-Object -ExpandProperty Id
        ) -or $_.OwningProcess -in $ProcessIds) -and
        ($Ports.Count -eq 0 -or $_.LocalPort -in $Ports)
    } |
    ForEach-Object {
        $process = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            ProcessName = $process.Name
            ProcessId   = $_.OwningProcess
            LocalPort   = $_.LocalPort
        }
    }
}