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

    $NewName = get-date -Format 'yyyyMMddTHHmmss'

    $Contents = Get-Content "D:\backup\*.txt"

    $source = $Contents[0].split("=")[1]
    $module = $Contents[1].split("=")[1]
    $action = $Contents[2].split("=")[1]
    $mail   = $Contents[3].split("=")[1]

    
    & $ScriptPath -Source $source -Module $module -Action $action -Mail $mail

    Copy-Item -Path 'D:\backup\*.txt' -Destination "D:\Stuff\$NewName" -Force -Verbose
    Remove-item -Path 'D:\backup\*.txt'
}