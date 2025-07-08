$menuTitle = "CommanDOS Loader ~ SzmelcINC"
$menuDir = ".\menu"
$selectedIndex = 0

function Get-ConfMenu {
    $files = Get-ChildItem -Path $menuDir -Filter *.conf
    $menuOptions = @()

    foreach ($file in $files) {
        $label = $file.BaseName -replace '[_\-]', ' '
        $fullPath = $file.FullName
        $menuOptions += @{ Label = $label; Path = $fullPath }
    }

    $menuOptions += @{ Label = "Exit"; Path = "exit" }
    return $menuOptions
}

function Draw-Menu {
    Clear-Host
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
            'UpArrow' { if ($subSelectedIndex -gt 0) { $subSelectedIndex-- } }
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

# Main loop
$menuOptions = Get-ConfMenu
[Console]::CursorVisible = $false

while ($true) {
    Draw-Menu
    $key = [Console]::ReadKey($true).Key
    switch ($key) {
        'UpArrow' { if ($selectedIndex -gt 0) { $selectedIndex-- } }
        'DownArrow' { if ($selectedIndex -lt $menuOptions.Count - 1) { $selectedIndex++ } }
        'Enter' {
            $choice = $menuOptions[$selectedIndex]
            if ($choice.Path -eq "exit") { Clear-Host; break }
            Run-SubMenuFromConf $choice.Path
            $menuOptions = Get-ConfMenu  # Reload in case of changes
        }
        'Escape' { break }
    }
}
