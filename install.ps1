# install.ps1
$destPath = "C:\CommanDOS"
$zipUrl = "https://github.com/Szmelc-INC/CommanDOS/archive/refs/heads/2.0.zip"
$zipFile = "$env:TEMP\CommanDOS.zip"
$desktopShortcut = "$([Environment]::GetFolderPath('Desktop'))\CommanDOS.lnk"

# 1. Prepare destination folder
if (Test-Path $destPath) {
    Write-Host "🧹 Clearing existing CommanDOS folder..."
    Remove-Item "$destPath\*" -Recurse -Force -ErrorAction SilentlyContinue
} else {
    New-Item -ItemType Directory -Path $destPath | Out-Null
}

# 2. Download ZIP from GitHub branch
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile

# 3. Extract ZIP
Expand-Archive -Path $zipFile -DestinationPath $env:TEMP -Force
Move-Item -Path "$env:TEMP\CommanDOS-2.0\*" -Destination $destPath -Force

# Cleanup ZIP + temp dir
Remove-Item $zipFile
Remove-Item "$env:TEMP\CommanDOS-2.0" -Recurse -Force

# 4. Create shortcut to main.ps1
$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($desktopShortcut)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$destPath\main.ps1`""
$shortcut.WorkingDirectory = $destPath
$shortcut.IconLocation = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$shortcut.Save()

Write-Host "✅ CommanDOS installed to C:\CommanDOS and shortcut created on Desktop."
