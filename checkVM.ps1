function Get-HyperVVMStatus {
    param(
        [string]$DomainController = "tvidc02",
        [string]$DomainCredential = "tvimp3\zredmond-da",
        [string]$DistinguishedName = "OU=HV,OU=TVI_Servers,OU=TVI_Global,DC=local,DC=tvi-mp3,DC=com"
    )

    try {
        $cred = Get-Credential $DomainCredential

        $HVList = Invoke-Command -Credential $cred -ComputerName $DomainController -ScriptBlock {
            param($DN)
            Get-ADComputer -SearchBase $DN -Filter * | Select-Object -ExpandProperty Name
        } -ArgumentList $DistinguishedName

        $results = Invoke-Command -ComputerName $HVList -Credential $cred -ScriptBlock {
            Get-VM | ForEach-Object {
                [PSCustomObject]@{
                    VMName = $_.Name
                    State = $_.State
                    Host = $env:COMPUTERNAME
                }
            }
        }

        $groupedVMs = $results | Group-Object -Property State
        $output = foreach ($group in $groupedVMs) {
            $state = $group.Name
            $group.Group | ForEach-Object {
                [PSCustomObject]@{
                    State = $state
                    Host = $_.Host
                    VMName = $_.VMName
                }
            }
        }

        return $output
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}