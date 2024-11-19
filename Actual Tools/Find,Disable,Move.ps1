# Import AD Module
Import-Module ActiveDirectory

# Define Parameters
$InactiveDays = 30
$CutOffDate = (Get-Date).AddDays(-$InactiveDays)
$TargetOU = "OU=DisabledUsers,DC=Adatum,DC=com"

# Get Inactive Users
$InactiveAccounts = Get-ADUser -Filter * -Credential $Creds -Property SamAccountName, LastLogonDate | Where-Object {
    $_.Enabled -eq $true -and ($_.LastLogonDate -lt $CutoffDate -or !$_.LastLogonDate)
}


# Check for Inactive Users
if ($InactiveAccounts.Count -eq 0) {
    Write-Host "No users found that have been inactive for $InactiveDays or more." -ForegroundColor DarkRed
    return
}

# ForEach Inactive User
foreach ($Account in $InactiveAccounts) {
    try {
        # Disable User
        Disable-ADAccount -Identity $Account.SamAccountName
        Write-Host "Disabled User: $($Account.SamAccountName)" -ForegroundColor DarkMagenta
        
        # Move User to TargetOU
        Move-ADObject -Identity $Account.DistinguishedName -TargetPath $TargetOU
        Write-Host "Moved User $($Account.SamAccountName) to OU: $TargetOU" -ForegroundColor DarkMagenta
    }
    catch {
        Write-Host "Failed to Process User: $($Account.SamAccountName)" -ForegroundColor DarkRed
        Write-Host $_.Exception.Message
    }
}

Write-Host "Completed Processing Inactive Users!" -ForegroundColor DarkGreen