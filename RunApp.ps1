Param(
    [string]$source,
    [string]$module,
    [String]$action,
    [String]$mail
)

<#Import-module "sqlps" -DisableNameChecking
$DMTPath = "C\Epicor\ERP10\LocalClients\ERP10\DMT.exe"
$User = "epicor"
$Pass = "epicor"
$Source = $source
$action = $action
$Module = $module
$Mail = $mail
$completeLog = $source + ".CompleteLog.txt"

#Load Data
Start-Process -Wait -FilePath $DMTPath -ArgumentList "-User $User -Pass $Pass -Action $Action -Import $Module -Source $Source"

#Check Results
select-string -Path $completeLog -Pattern "Records:\D*(\d+\/\d+)" -AllMatches | % { $_.Matches.Groups[0].Value }
select-string -Path $completeLog -Pattern "Errors:\D*(\d+)" -AllMatches | % { $_.Matches.Groups[0].Value }

Send-MailMessage -From DMT@yourcompany.com -Subject "Job Done" -To $Mail -Attachments $completeLog -Body "DMT Completed" -SmtpServer localhost#>

Write-Host "source: " $source
Write-Host "action: " $action
Write-Host "module: " $module
Write-Host "mail: " $mail
