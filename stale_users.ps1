# Checks local users to find "stale users" and logs them onto a csv
# Stale Users are users that've never logged in or are older than the cutoff variable

$outputPath = Join-Path -Path $PSScriptRoot -ChildPath "\export-logs\output.csv"
$cutoff = (Get-Date).AddDays(-90)

$staleUsers = Get-LocalUser | Where-Object {
    $_.Enabled -and ($null -eq $_.LastLogon -or $_.LastLogon -le $cutoff)
}

$staleUsers |
    Select-Object Name, Enabled, LastLogon |
    Export-Csv -Path $outputPath

Write-Output "Found $($staleUsers.Count) stale account(s).  Exported to $outputPath"