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
    #$Contents = [io.file]::ReadAllLines("D:\backup\$TxtFile")
    <#
    $source = $Contents[0].split("=")[1]
    $module = $Contents[1].split("=")[1]
    $action = $Contents[2].split("=")[1]
    $mail   = $Contents[3].split("=")[1]
#>
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

<#
hashtable
i onda
recimo hashtable nek se zove params
$params = @{};
i provrtis po linijama petlju
i unutar petlje
$params[...split[0]] = ...split[1]
i onda dok zoves skriptu ces imat
npr. scriptpath -Module $params["module"] -....
itd.

Pa ono
Table["ruda"]=555
I tak
Tak on radi
Mozes mu string dat ko indeks
Tak bi ti mogo foreach
Po redovima fajla
Vrtit
I ono
table[dio prije znaka =] = dio poslje znaka =
Dio prije znaka = je ono split 0
A poslje je split 1
Ono kak si napravio
Split
#>


<#while($true){
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
<
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

za module
i source
itd.
provjeriš jel null
ili prazan string
npr.
pa baciš grešku
kao
da je null

a imas onu metodu
ono kaj smo neki dan gledali
isto sa file watcherom
al ono dok mu daš callback
pa ce ti on asinkrono pozvat callback
kažeš mu nek gleda taj folder i ak se stvori file nek pozove callback funkciju
i onda nakon toga prazna while true petlja
al nek u njoj piše nešt tipa nek se ispisuje watching folder...
il tak nešt
#>