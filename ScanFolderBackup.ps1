Set-StrictMode -Version 2.0

$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path  = "D:\backup"
$FileSystemWatcher.EnableRaisingEvents = $false
$FileSystemWatcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::filename
$ScriptPath = "C:\Users\RudolfB\Desktop\Scripts\SecondScript.ps1"


while($true){
    $result = $FileSystemWatcher.WaitForChanged([System.IO.WatcherChangeTypes]::Changed -bor [System.IO.WatcherChangeTypes]::Renamed -bOr [System.IO.WatcherChangeTypes]::Created, 1000);
    if($result.TimedOut){
        continue;
    }

    Write-Host "Change in " + $result.Name

    $TxtFile = $result.Name
    $NewName = get-date -Format 'yyyyMMddTHHmmss'

    $Contents = Get-Content "D:\backup\$TxtFile"
    $FileContent = @{}

    foreach ($Line in $Contents){
        $FileContent[$Line.split('=').trim()[0]] = ($Line.split('=').trim()[1])
    }

    Write-Host "Source after split: " $FileContent["module"]
    #& $ScriptPath -Source $source -Module $module -Action $action -Mail $mail

    & $ScriptPath -Source $FileContent["source"] -Module $FileContent["module"] -Action $FileContent["action"] -Mail $FileContent["mail"]

    Copy-Item -Path D:\backup\$TxtFile -Destination D:\Stuff\$NewName.txt -Force -Verbose
    Remove-item -Path D:\backup\$TxtFile
}