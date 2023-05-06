# Spawn GodMode Folder
echo "Create Shell dir"
Start-Sleep -Seconds 1
clear
Start-Sleep -Seconds 1
Write-Host "`n=========================================="
Write-Host "||    [Szmelc-CommanDOS_x64] [ps1]      ||"
Write-Host "=========================================="
Write-Host "|| [mkdir C:\Shell] [Desktop Shortcut]  ||"
Write-Host "|| [Szmelc.INC - SilverX / POWER-TOOLS  ||"
Write-Host "=========================================="
Start-Sleep -Seconds 1

# Check if the Shell directory exists in C:\
$ShellPath = "C:\Shell"
if (!(Test-Path $ShellPath)) {
    # Create the Shell directory
    New-Item -Path $ShellPath -ItemType Directory
}

# Create a shortcut to the Shell directory on the desktop
$ShellShortcut = Join-Path ([Environment]::GetFolderPath("Desktop")) "Shell.lnk"
if (!(Test-Path $ShellShortcut)) {
    # Create the shortcut
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShellShortcut)
    $Shortcut.TargetPath = $ShellPath
    $Shortcut.Save()
}


Start-Sleep -Seconds 1
Write-Host "==========================================`n"
Start-Sleep -Seconds 1
Write-Host "`n Created [C:\Shell] directory path "
Write-Host " `nTHANKS FOR CHOOSING SZMELC <3`n"