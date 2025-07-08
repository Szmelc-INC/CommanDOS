# ───── Permanently Enable Script Execution ──────────────────────────
function Enable-ExecutionPolicy {
    try {
        Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction Stop
        Write-Host "🛡️ Script ExecutionPolicy set to 'Unrestricted' for LocalMachine" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Could not set ExecutionPolicy. Run as Administrator." -ForegroundColor Red
    }
}

# ───── Add szmelc Global Command ────────────────────────────────────
function Add-GlobalCommand {
    $cmdPath = "$env:WINDIR\System32\szmelc.cmd"
    $scriptPath = "$destPath\main.ps1"
    $cmdContent = "@echo off`r`nPowerShell -NoProfile -ExecutionPolicy Bypass -Command ""Start-Process PowerShell -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy Bypass','-File `"\""$scriptPath`\"""""
    Set-Content -Path $cmdPath -Value $cmdContent -Encoding ASCII -Force
    Write-Host "💻 'szmelc' command added (as admin launcher)" -ForegroundColor Green
}

# ───── Pin to Start Menu and Taskbar ────────────────────────────────
function Pin-ToStartAndTaskbar {
    $startMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\CommanDOS.lnk"
    Copy-Item $desktopShortcut $startMenuPath -Force

    $shell = New-Object -ComObject Shell.Application
    $folder = $shell.Namespace((Split-Path $startMenuPath))
    $item = $folder.ParseName((Split-Path $startMenuPath -Leaf))
    $item.InvokeVerb("Pin to Tas&kbar")  # localized name may vary
}
