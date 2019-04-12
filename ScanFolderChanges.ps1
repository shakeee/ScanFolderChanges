Set-StrictMode -Version 2.0

$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path  = "D:\backup"
$FileSystemWatcher.EnableRaisingEvents = $false
$FileSystemWatcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::filename
$ScriptPath = ".\TestOutput.ps1"


while($true){
    $Result = $FileSystemWatcher.WaitForChanged([System.IO.WatcherChangeTypes]::Changed -bor [System.IO.WatcherChangeTypes]::Renamed -bOr [System.IO.WatcherChangeTypes]::Created, 1000);
    if($result.TimedOut){
        continue;
    }

    #Writes name of file that is added
    Write-Host "Change in " + $Result.Name

    $TxtFile = $Result.Name
    $FileContent = @{}

    $NewName = get-date -Format 'yyyyMMddTHHmmss'

    #Location of folder which is being watched
    $Contents = Get-Content "D:\backup\$TxtFile"

    #Splitting variable and value from .txt file and adding them to hash table $FileContent
    foreach ($Line in $Contents){
        $FileContent[$Line.split('=').trim()[0]] = ($Line.split('=').trim()[1])
    }

    #Start other script with forwarded parameters from .txt file
    & $ScriptPath -Source $FileContent["source"] -Module $FileContent["module"] -Action $FileContent["action"] -Mail $FileContent["mail"]

    #Copying item to new destination, renaming it and removing from watched folder
    Copy-Item -Path D:\backup\$TxtFile -Destination D:\Stuff\$NewName.txt -Force -Verbose
    Remove-item -Path D:\backup\$TxtFile
}