ForEach ($system in Get-Content "test.txt"){
Write-Host "============================================================" -ForegroundColor "Yellow" 
Write-Host $system Retention change
Write-Host "============================================================" -ForegroundColor "Yellow" 
Write-Host ""
bpexpdate -recalculate -backupid $system -ret 1 -force
bpimagelist -backupid $system -L | Select-String "Expiration Time:|Sched Label"
}
