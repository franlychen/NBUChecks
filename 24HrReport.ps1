# Last 24 Hours Audit Script for NetBackup
# By: Daniel Groeschen
# 
#	Version 0.1 Initial Release
#
#
# 
# 	Script pulls the latest report from bperror and formats
#	it into a csv file and will write to $OutputPth 
#	Directory and $OutputFile filename.
#
#

$OutputPth = "E:\scripts\Previous24" # Path to $outputfile 
$Now = get-date -uformat "%m-%d-%Y"
$OutputFile = "Last24-" + $Now + ".csv" # Name of outputfile 

Switch (Test-Path $OutputPth) # Check if $OutputPth exists 
{ 
 False # If $OutputPth does not exist 
 { 
  New-Item $OutputPth -ItemType Directory | Out-Null # Create $OutputPth 
  Write-Host "Output Path did not exist, it was created: $OutputPth" -ForegroundColor "White" # Write to console 
  Write-Host "----------" -ForegroundColor "Yellow" # Write to console 
 } 
} 
$OutputStr = $OutputPth + "\" + $OutputFile # Combine $OutputPth and $OutputFile to a single string 

Start-Transcript -path $OutputStr -append
$ErrorActionPreference="SilentlyContinue"
$ErrorActionPreference = "Continue"


bperror -problems -backstat -l -hoursago 24 -columns 100 | ForEach-Object {$_ -Replace  "\s",","} | ForEach-Object {$_ -replace ",,",","}


Stop-Transcript | out-null