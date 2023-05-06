# Create Desktop Shortcuts
echo "Create Shell dir"
Start-Sleep -Seconds 1
clear
Start-Sleep -Seconds 1
Write-Host "`n=========================================="
Write-Host "||    [Szmelc-CommanDOS_x64] [ps1]      ||"
Write-Host "=========================================="
Write-Host "||   [mkdir-misc] [Desktop Shortcuts]   ||"
Write-Host "|| [Szmelc.INC - SilverX / POWER-TOOLS  ||"
Write-Host "=========================================="
Start-Sleep -Seconds 1
Write-Host "Creating Shortcuts for:"
Write-Host "=========================================="
Start-Sleep -Seconds 1
Write-Host "System32`nDownloads`nShell`nProgram Files"


# Sys32 Shortcut
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\System32.lnk")
$shortcut.TargetPath = "C:\Windows\System32"
$shortcut.Save()

# Shell Shortcut
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\Shell.lnk")
$shortcut.TargetPath = "C:\Shell"
$shortcut.Save()

# Downloads Shortcut
$CurrentUser = [Environment]::UserName
$DownloadsPath = "C:\Users\$CurrentUser\Downloads"
$ShortcutFile = "$([Environment]::GetFolderPath('Desktop'))\Downloads.lnk"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $DownloadsPath
$Shortcut.Save()

$ShortcutFile = "$([Environment]::GetFolderPath('Desktop'))\Program Files.lnk"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = "C:\Program Files"
$Shortcut.Save()

Start-Sleep -Seconds 1
Write-Host "==========================================`n"
Start-Sleep -Seconds 1
Write-Host "`n Created Shortcuts"
Write-Host " `nTHANKS FOR CHOOSING SZMELC <3`n"