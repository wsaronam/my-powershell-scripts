# Looks through a log and finds possible brute-force login attempts
# Searches through auth.log and exports failed logins surpassing or equal to the loginCount
# and exports the findings to a csv.




$outputPath = Join-Path $PSScriptRoot "export-logs\failed_logins_res.csv"
$logPath = Join-Path $PSScriptRoot "auth.log"
$loginCount = 3

Select-String -Path $logPath -Pattern "Failed password" |
    ForEach-Object {
        if ($_.Line -match "from (\d{1,3}(?:\.\d{1,3}){3})") {
            $Matches[1]
        }
    } |
    Group-Object |
    Where-Object { $_.Count -ge $loginCount } |
    Select-Object Name, Count |
    Export-Csv -Path $outputPath

Write-Output "Report saved to $outputPath"