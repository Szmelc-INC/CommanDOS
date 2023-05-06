Write-Host "`n=========================================="
Write-Host "||    [Szmelc-CommanDOS_x64] [ps1]      ||"
Write-Host "=========================================="
Write-Host "||   [Create new powershell.ps1 file]   ||"
Write-Host "|| [Szmelc.INC - SilverX / AMELIORATION ||"
Write-Host "==========================================`n"
Start-Sleep -Seconds 1

Write-Host "Create szmelc directory on your Desktop: [C:\Usr\Desktop\szmelc]"
Start-Sleep -Seconds 1
Write-Host "Create new powershell script NewScript.ps1 file with echo 'Hello World' inside Desktop\szmelc"

Start-Sleep -Seconds 1

cd $env:userprofile\Desktop
New-Item -ItemType Directory -Name "szmelc"
cd $env:userprofile\Desktop\szmelc
New-Item -ItemType File -Name "NewScript.ps1" -Value "Write-Host 'Hello, World!'"

Start-Sleep -Seconds 2
Write-Host "In case of errors, either:"
Start-Sleep -Seconds 1
Write-Host "Desktop\szmelc already exist"
Start-Sleep -Seconds 1
Write-Host "NewScript.ps1 already exist"
Start-Sleep -Seconds 1
Write-Host "Or both...`n"
Start-Sleep -Seconds 2
Write-Host "`n========= 
Run [.\script.ps1] to execute script directly 
Run [ls] to show current directory contents 
Run [cd] to change directory 
Run [exit] to exit`n=========`n"

Write-Host "Terminating in 3s..."
Write-Host "`n`n THANK YOU FOR CHOOSING SZMELC <3 `n`n"
Start-Sleep -Seconds 3
cd C:\Shell
exit