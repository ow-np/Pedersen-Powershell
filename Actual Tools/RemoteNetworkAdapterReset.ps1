# List of Target Computer(s)
$Computers = @("LON-DC1", "LON-SVR1")

# Credential Prompt
$Credential = Get-Credential -Message "ENTER ADMINISTRATOR CREDENTIALS FOR REMOTE COMPUTER(S)!"

# ScriptBlock to Reset Network Adapters
$ScriptBlock = {
    try {
        $Adapters = Get-NetAdapter -ErrorAction Stop

        foreach ($Adapter in $Adapters) { 
            Disable-NetAdapter -Name $Adapter.Name -Confirm:$false -ErrorAction Stop
            Start-Sleep -Seconds 5
            Enable-NetAdapter -Name $Adapter.Name -Confirm:$false -ErrorAction Stop
        }

        Write-Output "NETWORK ADAPTERS SUCCESSFULLY RESET ON $env:COMPUTERNAME"
    } catch {
        Write-Error "FAILED TO RESET NETWORK ADAPTERS ON $env:COMPUTERNAME: $_"
    }
}

# Execute ScriptBlock on Each Remote Computer
foreach ($Computer in $Computers) {
    Write-Output "PROCESSING $Computer..."
    Invoke-Command -ComputerName $Computer -Credential $Credential -ScriptBlock $ScriptBlock -ErrorAction Stop
}