# Last Backup Audit Script for NetBackup
# By: Daniel Groeschen
# 
#	Version 0.1 Initial Release
#
#
# backups_for_month.txt
# 	Should contain hostnames / IPs of systems within NetBackup
#	and will report the last successful backup date back.
#	This will write to $OutputPth Directory and $OutputFile 
#	filename.
#

$OutputPth = "E:\scripts" # Path to $outputfile 
$Now = get-date -uformat "%m-%d-%Y"
$OutputFile = "AuditBackup-" + $Now + ".txt" # Name of outputfile 

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

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path $OutputStr -append

ForEach ($system in Get-Content "clientlist_up")
{
	echo ========================
	echo $system
	bpimagelist -U -client $system -d 04/01/2014 -e 04/30/2014 | Select -First 5
}
Stop-Transcript
(gc $OutputStr ) | ? {$_.trim() -ne ""} | set-content $OutputStr