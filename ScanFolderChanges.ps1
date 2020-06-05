$ErrorActionPreference = 'Continue'
Set-StrictMode -Version 2.0

$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path  = "D:\DMT"
$FileSystemWatcher.EnableRaisingEvents = $true

Get-EventSubscriber -Force | Where-Object{$_.EventName -ieq 'Created'} | Unregister-Event -Force
$job = Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Created -Action {
    $time = $Event.TimeGenerated;
    $Result = $Event.SourceEventArgs.Name;
    $eventType = $Event.SourceEventArgs.ChangeType;

    Write-Host "$eventType $Result at $time";

    $TxtFile = $Result
    $FileContent = @{}

    $NewName = get-date -Format 'yyyyMMddTHHmmss'
    #Location of folder which is being watched
    $Contents = Get-Content "D:\DMT\$TxtFile"
    
    #Splitting variable and value from .txt file and adding them to hash table $FileContent
    foreach ($Line in $Contents){
        $FileContent[$Line.split('=').trim()[0]] = ($Line.split('=').trim()[1])
    }

    #Copying item to new destination, renaming it and removing from watched folder
    Copy-Item -Path D:\DMT\$TxtFile -Destination D:\DMT\History\$NewName.txt -Force -Verbose
    Remove-item -Path D:\DMT\$TxtFile

    #Start other script with forwarded parameters from .txt file
    & ".\TestOutput.ps1" -Source $FileContent["source"] -Module $FileContent["module"] -Action $FileContent["action"] -Mail $FileContent["mail"]
}

while($true){
   Start-Sleep -Seconds 1;
   Write-Host "watching folder..."
   Receive-Job -Job $job
}