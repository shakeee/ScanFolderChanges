Set-StrictMode -Version 2.0
$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path  = "D:\backup"
$FileSystemWatcher.EnableRaisingEvents = $false
$FileSystemWatcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::filename
$ScriptPath = "C:\Users\RudolfB\Desktop\Scripts\SecondScript.ps1"

<#Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Created -Action {
   $time = $Event.TimeGenerated;
   $filename = $Event.SourceEventArgs.FullPath;
   $eventType = $Event.SourceEventArgs.ChangeType;

   Write-Host "$eventType $filename at $time";
}#>

while($true){
    $result = $FileSystemWatcher.WaitForChanged([System.IO.WatcherChangeTypes]::Changed -bor [System.IO.WatcherChangeTypes]::Renamed -bOr [System.IO.WatcherChangeTypes]::Created, 1000);
    if($result.TimedOut){
        continue;
    }
    Write-Host "Change in " + $result.Name
    $NewName = get-date -Format 'yyyyMMddTHHmmss'

    $Contents = Get-Content "D:\backup\*.txt"

    $source = $Contents[0].split("=")[1]
    $module = $Contents[1].split("=")[1]
    $action = $Contents[2].split("=")[1]
    $mail   = $Contents[3].split("=")[1]

    Invoke-Expression $ScriptPath 

    Copy-Item -Path 'D:\backup\*.txt' -Destination "D:\Stuff\$NewName" -Force -Verbose
    Remove-item -Path 'D:\backup\*.txt'
}











<#Powershell-Script – Requirements:

We need a PowerShell Script which does the following:

The script will run on a virtual machine (Windows 10 Pro).
First it should monitor a folder (C:\DMT\) for new files (FileSystemWatcher??)
Into that folder there will come txt files (this filetype and content could be adjusted if needed)
As soon as there is a new file into that folder the script should open the file and read the content and write it into variables in the script, e.g.:
Content of the file could look like:
$Source = “C:\DMT\file1234.txt”
$module=”ShipHead”
$action= “-Update”
$mail = “brian.dorr at aol.com”
Then the script should write that content in the required variables:
And then it should run that script with the variables from the file (red marked variables are coming from txt file):
Import-module "sqlps" -DisableNameChecking
$DMTPath = "C:\Epicor\ERP10\LocalClients\ERP10\DMT.exe"
$User = "epicor"
$Pass = "epicor"
$Source = from txt-file
$Action = from txt-file
$Module = from txt file
$Mail = from txt file
$completeLog = $source + ".CompleteLog.txt"

#Load Data
Start-Process -Wait -FilePath $DMTPath -ArgumentList "-User $User -Pass $Pass $Action -Import $Module -Source $Source "
#Check Results
select-string -Path $completeLog -Pattern "Records:\D*(\d+\/\d+)" -AllMatches | % { $_.Matches.Groups[0].Value }
select-string -Path $completeLog -Pattern "Errors:\D*(\d+)" -AllMatches | % { $_.Matches.Groups[0].Value }

Send-MailMessage -From DMT at yourcompany.com -Subject "Job Done" -To $Mail -Attachments $completeLog -Body "DMT Completed" -SmtpServer localhost

After that the script should rename the txt file and move it into the folder C:\DMT\History. Also, the file from the $Source path should be moved into the History folder. 
The folder should be monitored permanently for new txt files and should execute the script. less


u windowsima postoji vjerojatno u win api ugrađena funkcija tak neka
koju pozoveš
i daš joj callback
funkciju koju da pozove
dok se promijeni nešt u folderu nekom
i onda windowsi čim neko kreira file
pozove tvoju funkciju
ako je file kreiran u tom folderu
   https://docs.microsoft.com/en-us/windows/desktop/api/fileapi/nf-fileapi-findfirstchangenotificationa   
to je ta funkcija valjda
al tebe ona ne zanima ustvari
imaš fino ovu .net filesystemwatcher klasu
koja to koristi u pozadini
?#>