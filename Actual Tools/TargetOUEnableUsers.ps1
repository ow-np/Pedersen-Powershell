# Import AD Module
Import-Module ActiveDirectory

#Define Target OU
$TargetOU = "OU=DisabledUsers,DC=Adatum,DC=com" 

# Get All Disabled Users in Target OU
$DisabledUsers = Get-ADUser -Filter {Enabled -eq $false} -SearchBase $TargetOU -Properties Enabled

# Check if there are any Disabled Users
if ($DisabledUsers.Count -eq 0) {
    Write-Host "No Disabled Users Found in Target OU: $TargetOU" -ForegroundColor DarkRed
    return
}

# Re-enable Each User
foreach ($User in $DisabledUsers) {
    try {
        Enable-ADAccount -Identity $User.SamAccountName
        Write-Host "Re-enabled User: $($User.SamAccountName)" -ForegroundColor DarkGreen
    }
    catch {
        Write-Host "Failed to Re-enable User: $($User.SamAccountName)" -ForegroundColor DarkRed
        Write-Host $_.Exception.Message
    }
}