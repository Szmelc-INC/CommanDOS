Write-Host "`n=========================================="
Write-Host "||    [Szmelc-CommanDOS_x64] [ps1]      ||"
Write-Host "=========================================="
Write-Host "|| [Windows Activate -- Show Hard Info] ||"
Write-Host "|| [Szmelc.INC - SilverX / AMELIORATION ||"
Write-Host "==========================================`n"
Start-Sleep -Seconds 1
Write-Host "Executing: 'Set-ExecutionPolicy Unrestricted'"
Start-Sleep -Seconds 1
Write-Host "Executing: 'slmgr /ato'"
Start-Sleep -Seconds 2

Set-ExecutionPolicy Unrestricted
Write-Host "`nExecution Policy: Unrestricted"
Start-Sleep -Seconds 1
slmgr /ato
Write-Host "Activate OS"

Write-Host "Terminating in 3s...`n`n"
Write-Host " THANK YOU FOR CHOOSING SZMELC <3 `n`n "
Start-Sleep -Seconds 3
exit

