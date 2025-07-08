# CommanDOS Installer Script by Szmelc.INC

# ───── Setup ────────────────────────────────────────────────────────
$destPath = "C:\CommanDOS"
$zipUrl = "https://github.com/Szmelc-INC/CommanDOS/archive/refs/heads/2.0.zip"
$zipFile = "$env:TEMP\CommanDOS.zip"
$desktopShortcut = "$([Environment]::GetFolderPath('Desktop'))\CommanDOS.lnk"
$readmePath = Join-Path $destPath "README.md"
$backupPath = "$env:TEMP\CommanDOS_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
$tempExtractPath = "$env:TEMP\CommanDOS_TMP_$(Get-Random)"

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
    Write-Host "4. Run as Portable"
    Write-Host "5. Check For Updates"
    Write-Host "6. Start CommanDOS"
    Write-Host "7. Run Command Validator"
    Write-Host "0. Exit`n"
    do {
        $choice = Read-Host "Select an option [0-7]"
    } while ($choice -notmatch '^[0-7]$')
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

# ───── Run Portable ─────────────────────────────────────────────────
function Run-Portable {
    Write-Host "📥 Downloading temporary copy..."
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $tempExtractPath -Force
    Remove-Item $zipFile -Force
    $portableMain = Join-Path "$tempExtractPath\CommanDOS-2.0" "main.ps1"
    Write-Host "🚀 Running Portable CommanDOS..."
    Start-Process powershell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$portableMain`"" -Verb RunAs
}

# ───── Check for Updates ────────────────────────────────────────────
function Check-For-Updates {
    if (-not (Test-Path $destPath)) {
        Write-Host "⚠️ CommanDOS is not installed." -ForegroundColor Red
        return
    }

    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $tempExtractPath -Force
    Remove-Item $zipFile -Force

    $newFiles = Get-ChildItem "$tempExtractPath\CommanDOS-2.0" -Recurse
    $oldFiles = Get-ChildItem $destPath -Recurse

    Write-Host "`n📊 Comparing installed files with latest version..."
    foreach ($file in $newFiles) {
        $relativePath = $file.FullName.Replace("$tempExtractPath\CommanDOS-2.0\", "")
        $oldFilePath = Join-Path $destPath $relativePath

        if (!(Test-Path $oldFilePath)) {
            Write-Host "🆕 New: $relativePath" -ForegroundColor Green
        } elseif ((Get-FileHash $file.FullName).Hash -ne (Get-FileHash $oldFilePath).Hash) {
            Write-Host "✏️  Modified: $relativePath" -ForegroundColor Yellow
            $action = Read-Host "→ Replace, keep old or merge? [r/k/m]"
            switch ($action) {
                'r' { Copy-Item $file.FullName -Destination $oldFilePath -Force }
                'k' { Write-Host "→ Kept old version." }
                'm' { notepad $oldFilePath; notepad $file.FullName }
            }
        }
    }

    Remove-Item $tempExtractPath -Recurse -Force
    Write-Host "`n✅ Update check complete."
}

# ───── Start CommanDOS ──────────────────────────────────────────────
function Start-CommanDOS {
    $mainScript = Join-Path $destPath "main.ps1"
    if (Test-Path $mainScript) {
        Start-Process powershell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$mainScript`"" -Verb RunAs
    } else {
        Write-Host "❌ main.ps1 not found in $destPath" -ForegroundColor Red
    }
}

# ───── Run Validator (validate.ps1) ─────────────────────────────────
function Run-Validator {
    $validator = Join-Path $destPath "validate.ps1"
    if (Test-Path $validator) {
        Start-Process powershell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$validator`"" -Verb RunAs
    } else {
        Write-Host "❌ validate.ps1 not found in $destPath" -ForegroundColor Red
    }
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

# ───── Main Menu Loop ───────────────────────────────────────────────
while ($true) {
    switch (Show-Menu) {
        '1' { Install-Or-Update }
        '2' { Uninstall-CommanDOS }
        '3' { Show-Help }
        '4' { Run-Portable }
        '5' { Check-For-Updates }
        '6' { Start-CommanDOS }
        '7' { Run-Validator }
        '0' { Write-Host "`n👋 Exiting..."; Start-Sleep 1; exit }
    }
    Write-Host "`nPress any key to return to menu..." -ForegroundColor Gray
    [Console]::ReadKey($true) | Out-Null
}
