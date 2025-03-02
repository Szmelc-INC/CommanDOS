$menuTitle = "CommanDOS ~ SzmelcINC"
$repoUrl = "https://github.com/Szmelc-INC/CommanDOS/"
$repoZip = "https://github.com/Szmelc-INC/CommanDOS/archive/refs/heads/main.zip"
$downloadPath = "$env:TEMP\CommanDOS.zip"
$extractPath = "$env:USERPROFILE\CommanDOS"

$menuOptions = @(
    @{ Label = "Install CommanDOS via Install Szmelc Wizard"; Command = {
        Clear-Host
        Write-Host "`nDownloading CommanDOS...`n" -ForegroundColor Yellow

        if (Get-Command git -ErrorAction SilentlyContinue) {
            Write-Host "Using Git..." -ForegroundColor Green
            git clone $repoUrl $extractPath
        }
        elseif (Get-Command wget -ErrorAction SilentlyContinue) {
            Write-Host "Using Wget..." -ForegroundColor Cyan
            wget $repoZip -OutFile $downloadPath
            Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force
        }
        else {
            Write-Host "Using Invoke-WebRequest (PowerShell)..." -ForegroundColor Magenta
            Invoke-WebRequest -Uri $repoZip -OutFile $downloadPath
            Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force
        }

        Write-Host "`nCommanDOS downloaded to $extractPath!`n" -ForegroundColor Green
        Write-Host "Press any key to return to menu..." -ForegroundColor Cyan
        [Console]::ReadKey($true) | Out-Null
    } }
    @{ Label = "Wget WinGet & Get Wget via WinGet"; Command = "winget install --id=GNU.Wget && winget install --id=Microsoft.Winget" }
    @{ Label = "Setup WSL - Bieda Linux Od buta"; Command = "wsl --install" }
    @{ Label = "More cool shit from NoMoreSoft & SzmelcINC"; Command = "Start-Process 'https://szmelc.com/coolshit'" }
    @{ Label = "Customowe menu"; Command = "Start-Process 'C:\path\to\custom_menu.ps1' -Wait" }
    @{ Label = "Exit"; Command = "exit" }
)

$selectedIndex = 0

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

function Run-Menu {
    [Console]::CursorVisible = $false
    while ($true) {
        Draw-Menu
        $key = [Console]::ReadKey($true).Key

        switch ($key) {
            'UpArrow' { if ($selectedIndex -gt 0) { $selectedIndex-- } }
            'DownArrow' { if ($selectedIndex -lt $menuOptions.Count - 1) { $selectedIndex++ } }
            'Enter' {
                $command = $menuOptions[$selectedIndex].Command
                if ($command -eq "exit") { Clear-Host; exit }
                if ($command -is [scriptblock]) {
                    & $command
                } else {
                    Clear-Host
                    Write-Host "`nExecuting: $($menuOptions[$selectedIndex].Label)...`n" -ForegroundColor Yellow
                    Invoke-Expression $command
                }
                Write-Host "`nPress any key to return to menu..." -ForegroundColor Cyan
                [Console]::ReadKey($true) | Out-Null
            }
            'Escape' { Clear-Host; exit }
        }
    }
}

Run-Menu
