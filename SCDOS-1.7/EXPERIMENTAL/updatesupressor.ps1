Write-Host "`n=========================================="
Write-Host "||    [Szmelc-CommanDOS_x64] [ps1]      ||"
Write-Host "=========================================="
Write-Host "|| [Windows Update Supressor - Disable] ||"
Write-Host "|| [Szmelc.INC - SilverX / AMELIORATION ||"
Write-Host "==========================================`n"
Start-Sleep -Seconds 1
Write-Host "Executing: 'Set-Service -Name wuauserv -StartupType Disabled'"
Start-Sleep -Seconds 1
Write-Host "Executing: 'Stop-Service -Name wuauserv'"
Start-Sleep -Seconds 2

Set-Service -Name wuauserv -StartupType Disabled
Write-Host "Startup Disabled"
Stop-Service -Name wuauserv
Write-Host "Service Stopped"

Write-Host "Terminating in 3s...`n`n"
Write-Host " THANK YOU FOR CHOOSING SZMELC <3 `n`n "
Start-Sleep -Seconds 3
exit

