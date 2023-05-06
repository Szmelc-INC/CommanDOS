# Define the function to display the menu
function Show-Menu
{
    Clear-Host
    Write-Host "`n===================================="
    Get-Content C:\Shell\ascii\.\1.txt
    Write-Host "`n===================================="
    Write-Host "=== [Szmelc-CommanDOS] [x86_x64] ==="
    Write-Host "==-== [Powershell.exe] -[.ps1] ==-=="
    Write-Host "===================================="
    Write-Host "`n================="
    Write-Host "1. Option 1"
    Write-Host "2. Option 2"
    Write-Host "3. Option 3"
    Write-Host "Q. Quit"
    Write-Host "=================`n"
    
}

# Define the function to process user input
function Process-Input
{
    $input = Read-Host "Enter your choice"
    switch ($input)
    {
        "1" { Option1 }
        "2" { Option2 }
        "3" { Option3 }
        "Q" { return $false }
        default { Write-Host "Invalid choice" }
    }
    return $true
}

# Define the function for option 1
function Option1
{
    Write-Host "You selected Option 1"
    # Add your code here
    cd C:\Shell
    .\1.ps1
    Pause
}

# Define the function for option 2
function Option2
{
    Write-Host "You selected Option 2"
    # Add your code here
    cd C:\Shell
    .\2.ps1
    Pause
}

# Define the function for option 3
function Option3
{
    Write-Host "You selected Option 3"
    # Add your code here
    cd C:\Shell
    .\3.ps1
    Pause
}

# Define the function to pause the script
function Pause
{
    Read-Host "Press Enter to continue"
}

# Start the script
$continue = $true
while ($continue)
{
    Show-Menu
    $continue = Process-Input
}
Clear-Host
Write-Host "`n`n THANKS FOR CHOOSING SZMELC <3 `n`n"
Start-Sleep -Seconds 3
.\ascii.ps1

