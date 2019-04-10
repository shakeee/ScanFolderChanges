<#$Values = Get-Content .\filesql.txt

$Source = $Values[0]

$contents = Get-Content .\filesql.txt

foreach($line in $contents) {
  $s = $line -split ('=')[1]
  $Source = $s[0]
  $module = $s[1]
  $action = $s[2]
  $mail   = $s[3]
  write-host $Source $module $action $mail
}#>

$Contents = Get-Content ".\filesql.txt"

$Source = $Contents[0].split("=")[1]
$module = $Contents[1].split("=")[1]
$action = $Contents[2].split("=")[1]
$mail   = $Contents[3].split("=")[1]

Write-host $Source
#Write-host ("{0}|{1}|{2}|{3}" -f $Source,$module,$action,$mail)