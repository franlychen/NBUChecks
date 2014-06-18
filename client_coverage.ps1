ForEach ($system in Get-Content "clients.txt")
{
Write-Host "============================================================" -ForegroundColor "Yellow" 
Write-Host $system Client Coverage
Write-Host "============================================================" -ForegroundColor "Yellow" 
Write-Host ""
bpcoverage -c $system -v
}