# ─── Validate.ps1 — CommanDOS Conf Validator ────────────────────────
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$defaultConfDir = "C:\CommanDOS\menu"

# ─── Choose .conf file ──────────────────────────────────────────────
function Pick-ConfFile {
    if (Test-Path $defaultConfDir -and (Get-ChildItem "$defaultConfDir\*.conf")) {
        Write-Host "`n📁 Found .conf files in $defaultConfDir:" -ForegroundColor Cyan
        $files = Get-ChildItem "$defaultConfDir\*.conf"
        for ($i = 0; $i -lt $files.Count; $i++) {
            Write-Host "  [$i] $($files[$i].Name)"
        }
        $sel = Read-Host "Select index [0-$($files.Count-1)]"
        if ($sel -match '^\d+$' -and $sel -lt $files.Count) {
            return $files[$sel].FullName
        }
    }

    while ($true) {
        $path = Read-Host "Enter path to a .conf file"
        if (Test-Path $path -and $path -like "*.conf") {
            return (Resolve-Path $path).Path
        } else {
            Write-Host "❌ Invalid path or not a .conf file." -ForegroundColor Red
        }
    }
}

$confFile = Pick-ConfFile

# ─── Load Lines ─────────────────────────────────────────────────────
$rawLines = Get-Content $confFile
$lines = @()
foreach ($line in $rawLines) {
    if ($line -match "^\s*#") { $lines += $line; continue }
    if ($line -match "\s*:\s*") { $lines += $line }
    else { $lines += $line }
}

# ─── Utilities ──────────────────────────────────────────────────────
function Get-TestCommand {
    param($cmd)
    return $cmd -replace '\$p', '"C:\TestFolder"' `
                 -replace '\$path', '"C:\TestFolder"' `
                 -replace '\$user', '"Everyone"' `
                 -replace '\$u', '"Everyone"' `
                 -replace '\$exe', '"notepad.exe"' `
                 -replace '\$v', '"01 00 00 00"' `
                 -replace '\$id', '"{00000000-0000-0000-0000-000000000000}"' `
                 -replace '\$n', '"TestVar"'
}

function Try-RunCommand {
    param($testCommand)
    try {
        Write-Host "`n[▶] Executing test: $testCommand" -ForegroundColor Yellow
        Invoke-Expression $testCommand
    } catch {
        Write-Host "`n[!] Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function OfferFix {
    param($line, $index)
    $original = $line
    $parts = $line -split "\s*:\s*", 2
    if ($parts.Count -ne 2) { return }
    $label = $parts[0].Trim()
    $command = $parts[1].Trim()

    # Strip wrapper
    $command = $command -replace '^powershell\s+-Command\s+[\'"]?', ''
    $command = $command -replace '[\'"]?$', ''

    $fixedLine = "$label : $command"
    if ($fixedLine -ne $original) {
        $script:lines[$index] = $fixedLine
        Write-Host "[✔] Fixed line." -ForegroundColor Green
    } else {
        Write-Host "[i] No fix needed." -ForegroundColor DarkGray
    }
}

function CopyAndOpen {
    param($command)
    Set-Clipboard -Value $command
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
    $encoded = [Convert]::ToBase64String($bytes)
    Start-Process powershell -ArgumentList "-NoExit", "-EncodedCommand", $encoded
    Write-Host "[✔] Opened in new PowerShell window." -ForegroundColor Cyan
}

# ─── Main Loop ──────────────────────────────────────────────────────
for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line.Trim() -eq "" -or $line -notmatch "\s*:\s*") { continue }

    $parts = $line -split "\s*:\s*", 2
    if ($parts.Count -ne 2) { continue }

    $label = $parts[0].Trim()
    $command = $parts[1].Trim()
    $testCommand = Get-TestCommand $command

    Write-Host "`n─────────────" -ForegroundColor Gray
    Write-Host "[#] $label" -ForegroundColor Cyan
    Write-Host "[~] Raw: $command" -ForegroundColor DarkGray

    Write-Host "[?] Options:"
    Write-Host "  [T] Test command"
    Write-Host "  [F] Attempt fix"
    Write-Host "  [C] Copy & open in new terminal"
    Write-Host "  [S] Skip"
    Write-Host "  [X] Exit"

    while ($true) {
        $choice = Read-Host "Choose action (T/F/C/S/X)"
        switch ($choice.ToUpper()) {
            "T" { Try-RunCommand $testCommand; break }
            "F" { OfferFix $line $i; break }
            "C" { CopyAndOpen $testCommand; break }
            "S" { break }
            "X" { Write-Host "Aborted." -ForegroundColor Red; exit 0 }
            default { Write-Host "Invalid choice." -ForegroundColor DarkRed }
        }
    }
}

# ─── Save if Changed ────────────────────────────────────────────────
if ($lines -join "`n" -ne ($rawLines -join "`n")) {
    $save = Read-Host "`nSave changes to $confFile? (y/n)"
    if ($save -eq "y") {
        $lines | Set-Content $confFile -Encoding UTF8
        Write-Host "[✔] Saved corrected file." -ForegroundColor Green
    } else {
        Write-Host "[i] Discarded changes." -ForegroundColor Yellow
    }
}
