ForEach ($system in Get-Content "systems.txt")
{
	Write-Host "============================================================" -ForegroundColor "Yellow" 
	Write-Host "$system Last 7 Days"
	Write-Host "============================================================" -ForegroundColor "Yellow" 
	Write-Host ""
	bpimagelist -U -client $system -hoursago 168 | Out-String
   
}