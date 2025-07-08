# Force UTF-8 output and wide-char support
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ─── Config ────────────────────────────────────────────────────────
$menuTitle = "- [CommanDOS] [v1.2]"
$selectedIndex = 0
$defaultDir = "C:\CommanDOS\menu"
$confPathArg = $args[0]
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$logoFile = Join-Path $scriptDir "logo.txt"

# ─── Load Logo (if exists) ─────────────────────────────────────────
function Show-Logo {
    if (Test-Path $logoFile) {
        $logo = Get-Content $logoFile -Encoding UTF8
        foreach ($line in $logo) {
            # Optional: center the line, accounting for wide chars
            $rawLen = ($line | Measure-Object -Character).Characters
            $pad = [Math]::Max(0, ([Console]::WindowWidth - $rawLen) / 2)
            Write-Output (" " * $pad + $line)
        }
        Write-Host ""
    }
}

# ─── Resolve Conf Source ───────────────────────────────────────────
function Resolve-ConfDirectory {
    if ($confPathArg) {
        if (Test-Path $confPathArg -PathType Leaf) {
            return @{ Mode = "file"; Value = (Resolve-Path $confPathArg).Path }
        }
        elseif (Test-Path $confPathArg -PathType Container) {
            return @{ Mode = "dir"; Value = (Resolve-Path $confPathArg).Path }
        }
    }
    elseif ((Test-Path $defaultDir -PathType Container) -and (Get-ChildItem $defaultDir -Filter *.conf)) {
        return @{ Mode = "dir"; Value = (Resolve-Path $defaultDir).Path }
    }
    elseif (Get-ChildItem . -Filter *.conf) {
        return @{ Mode = "dir"; Value = (Resolve-Path .).Path }
    }

    while ($true) {
        $input = Read-Host "Enter path to a .conf file or folder with .conf files"
        if (Test-Path $input -PathType Leaf) {
            return @{ Mode = "file"; Value = (Resolve-Path $input).Path }
        }
        elseif (Test-Path $input -PathType Container) {
            return @{ Mode = "dir"; Value = (Resolve-Path $input).Path }
        }
        Write-Host "Invalid path. Try again." -ForegroundColor Red
    }
}

$confSource = Resolve-ConfDirectory

# ─── Generate Menu from .conf Files ────────────────────────────────
function Get-ConfMenu {
    $menuOptions = @()

    if ($confSource.Mode -eq "file") {
        $menuOptions += @{
            Label = [System.IO.Path]::GetFileNameWithoutExtension($confSource.Value) -replace '[_\-]', ' '
            Path = $confSource.Value
        }
    } else {
        $files = Get-ChildItem -Path $confSource.Value -Filter *.conf
        foreach ($file in $files) {
            $menuOptions += @{
                Label = $file.BaseName -replace '[_\-]', ' '
                Path = $file.FullName
            }
        }
    }

    $menuOptions += @{ Label = "Exit"; Path = "exit" }
    return $menuOptions
}

# ─── Draw Menu ─────────────────────────────────────────────────────
function Draw-Menu {
    Clear-Host
    Show-Logo
    Write-Host "`n$menuTitle`n" -ForegroundColor Cyan
    for ($i = 0; $i -lt $menuOptions.Count; $i++) {
        if ($i -eq $selectedIndex) {
            Write-Host " > " -NoNewline -ForegroundColor Green
            Write-Host $menuOptions[$i].Label -ForegroundColor Green
        } else {
            Write-Host "   " -NoNewline
            Write-Host $menuOptions[$i].Label
        }
    }
}

# ─── Run Submenu from Selected .conf File ──────────────────────────
function Run-SubMenuFromConf($confPath) {
    $menuOptions = @()
    $lines = Get-Content $confPath | Where-Object { $_ -match "\s*:\s*" }
    
    foreach ($line in $lines) {
        $parts = $line -split "\s*:\s*", 2
        $label = $parts[0].Trim()
        $command = $parts[1].Trim()
        if ($command -eq "__INSTALL__") {
            $command = {
                Write-Host "`nDownloading CommanDOS...`n" -ForegroundColor Yellow
                $repoUrl = "https://github.com/Szmelc-INC/CommanDOS/"
                $repoZip = "https://github.com/Szmelc-INC/CommanDOS/archive/refs/heads/main.zip"
                $downloadPath = "$env:TEMP\CommanDOS.zip"
                $extractPath = "$env:USERPROFILE\CommanDOS"

                if (Get-Command git -ErrorAction SilentlyContinue) {
                    git clone $repoUrl $extractPath
                }
                elseif (Get-Command wget -ErrorAction SilentlyContinue) {
                    wget $repoZip -OutFile $downloadPath
                    Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force
                }
                else {
                    Invoke-WebRequest -Uri $repoZip -OutFile $downloadPath
                    Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force
                }

                Write-Host "`nCommanDOS downloaded to $extractPath!`n" -ForegroundColor Green
                Write-Host "Press any key to return to menu..." -ForegroundColor Cyan
                [Console]::ReadKey($true) | Out-Null
            }
        }
        $menuOptions += @{ Label = $label; Command = $command }
    }

    $subSelectedIndex = 0
    while ($true) {
        Clear-Host
        Write-Host "`n$confPath`n" -ForegroundColor Magenta
        for ($i = 0; $i -lt $menuOptions.Count; $i++) {
            if ($i -eq $subSelectedIndex) {
                Write-Host " > " -NoNewline -ForegroundColor Yellow
                Write-Host $menuOptions[$i].Label -ForegroundColor Yellow
            } else {
                Write-Host "   " -NoNewline
                Write-Host $menuOptions[$i].Label
            }
        }

        $key = [Console]::ReadKey($true).Key
        switch ($key) {
            'UpArrow'   { if ($subSelectedIndex -gt 0) { $subSelectedIndex-- } }
            'DownArrow' { if ($subSelectedIndex -lt $menuOptions.Count - 1) { $subSelectedIndex++ } }
            'Enter' {
                $command = $menuOptions[$subSelectedIndex].Command
                if ($command -eq "exit") { return }
                if ($command -is [scriptblock]) {
                    & $command
                } else {
                    Clear-Host
                    Write-Host "`nExecuting: $($menuOptions[$subSelectedIndex].Label)...`n" -ForegroundColor Cyan
                    Invoke-Expression $command
                }
                Write-Host "`nPress any key to return to submenu..." -ForegroundColor Gray
                [Console]::ReadKey($true) | Out-Null
            }
            'Escape' { return }
        }
    }
}

# ─── Main Menu Loop ────────────────────────────────────────────────
$menuOptions = Get-ConfMenu
[Console]::CursorVisible = $false

while ($true) {
    Draw-Menu
    $key = [Console]::ReadKey($true).Key
    switch ($key) {
        'UpArrow'   { if ($selectedIndex -gt 0) { $selectedIndex-- } }
        'DownArrow' { if ($selectedIndex -lt $menuOptions.Count - 1) { $selectedIndex++ } }
        'Enter' {
            $choice = $menuOptions[$selectedIndex]
            if ($choice.Path -eq "exit") { Clear-Host; break }
            Run-SubMenuFromConf $choice.Path
            $menuOptions = Get-ConfMenu  # refresh
        }
        'Escape' { break }
    }
}
