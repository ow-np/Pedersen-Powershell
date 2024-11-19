# Import AD Module
Import-Module ActiveDirectory

# Inactivity Threshold (in days)
$InactiveDays = 90

# Calculate for cutoff date
$CutOffDate = (Get-Date).AddDays(-$InactiveDays)

#Get Inactive User Accounts
$InactiveAccounts = Get-ADUser -filter * -Property SamAccountName, LastLogonDate | Where-Object {
$_.Enabled -eq $true -and ($_.LastLogonDate -lt $CutOffDate -or !$_.LastLogonDate)
} | Select-Object SamAccountName, LastLogonDate

#Results In a Table
Write-Host "Inactive User Accounts (Inactive for more than $InactiveDays days):" -ForegroundColor DarkRed
$InactiveAccounts | Format-Table -AutoSize

# Export to CSV
$InactiveDays | Export-CSV -Path "InactiveADAccounts.csv" -NoTypeInformation
Write-Host "Results exported to 'InactiveADAccounts.csv'" -ForegroundColor Green
