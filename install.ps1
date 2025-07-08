# CommanDOS Installer Script by SzmelcINC

# ───── Setup ────────────────────────────────────────────────────────
$destPath = "C:\CommanDOS"
$zipUrl = "https://github.com/Szmelc-INC/CommanDOS/archive/refs/heads/2.0.zip"
$zipFile = "$env:TEMP\CommanDOS.zip"
$desktopShortcut = "$([Environment]::GetFolderPath('Desktop'))\CommanDOS.lnk"
$readmePath = Join-Path $destPath "README.md"
$backupPath = "$env:TEMP\CommanDOS_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# ───── Detect Status ────────────────────────────────────────────────
function Get-Status {
    if (Test-Path $destPath) {
        $status = "[STATUS] ✅ CommanDOS is installed"
        if (Test-Path $readmePath) {
            $firstLine = Get-Content $readmePath -TotalCount 1
            $status += " → `"$firstLine`""
        }
    } else {
        $status = "[STATUS] ❌ CommanDOS is not installed"
    }
    return $status
}

# ───── Draw Interactive Menu ────────────────────────────────────────
function Show-Menu {
    Write-Host "`n==== CommanDOS Setup ====" -ForegroundColor Cyan
    Write-Host "$(Get-Status)" -ForegroundColor Yellow
    Write-Host "`n1. Install / Update"
    Write-Host "2. Uninstall"
    Write-Host "3. Help"
    Write-Host "0. Exit`n"
    do {
        $choice = Read-Host "Select an option [0-3]"
    } while ($choice -notmatch '^[0-3]$')
    return $choice
}

# ───── Create Shortcut with Admin Elevation ─────────────────────────
function Create-Shortcut {
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($desktopShortcut)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$destPath\main.ps1`""
    $shortcut.WorkingDirectory = $destPath
    $shortcut.IconLocation = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
    $shortcut.Save()

    # Enable "Run as Administrator" on the shortcut
    $bytes = [System.IO.File]::ReadAllBytes($desktopShortcut)
    $bytes[0x15] = 0x22
    [System.IO.File]::WriteAllBytes($desktopShortcut, $bytes)
}

# ───── Install or Update ────────────────────────────────────────────
function Install-Or-Update {
    if (Test-Path $destPath) {
        $yn = Read-Host "CommanDOS is already installed. Backup before update? [y/N]"
        if ($yn -match '^(y|Y)$') {
            Copy-Item $destPath $backupPath -Recurse -Force
            Write-Host "🔁 Backup created at: $backupPath" -ForegroundColor DarkGray
        }

        Write-Host "🧹 Clearing existing CommanDOS folder..."
        Remove-Item "$destPath\*" -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        New-Item -ItemType Directory -Path $destPath | Out-Null
    }

    Write-Host "`n⬇️  Downloading CommanDOS from GitHub..."
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile

    Write-Host "📦 Extracting..."
    Expand-Archive -Path $zipFile -DestinationPath $env:TEMP -Force
    Move-Item -Path "$env:TEMP\CommanDOS-2.0\*" -Destination $destPath -Force

    Write-Host "🧼 Cleaning up..."
    Remove-Item $zipFile -Force
    Remove-Item "$env:TEMP\CommanDOS-2.0" -Recurse -Force

    Write-Host "🧷 Creating desktop shortcut..."
    Create-Shortcut

    Write-Host "`n✅ CommanDOS installed to C:\CommanDOS"
    Write-Host "📎 Shortcut added to Desktop.`n"
}

# ───── Uninstall ────────────────────────────────────────────────────
function Uninstall-CommanDOS {
    if (Test-Path $destPath) {
        Remove-Item $destPath -Recurse -Force
        Write-Host "🗑️  Removed C:\CommanDOS" -ForegroundColor Red
    }
    if (Test-Path $desktopShortcut) {
        Remove-Item $desktopShortcut -Force
        Write-Host "🧹 Removed desktop shortcut" -ForegroundColor DarkRed
    }
}

# ───── Help ─────────────────────────────────────────────────────────
function Show-Help {
    Start-Process "https://github.com/Szmelc-INC/CommanDOS"
}

# ───── Main Logic ───────────────────────────────────────────────────
while ($true) {
    switch (Show-Menu) {
        '1' { Install-Or-Update }
        '2' { Uninstall-CommanDOS }
        '3' { Show-Help }
        '0' { break }
    }
    Write-Host "`nPress any key to return to menu..." -ForegroundColor Gray
    [Console]::ReadKey($true) | Out-Null
}
