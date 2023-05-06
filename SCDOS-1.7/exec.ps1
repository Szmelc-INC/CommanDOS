# CommanDOS 1.6 Main Entry point .ps1
# Execute by opening powershell.exe as administrator & running:
# cd C:\<script_path>
# .\exec.ps1

# Define the function to display the menu
function Show-Menu
{
    Clear-Host 
    Get-Content C:\SCDOS\.\ascii\c1.txt
    # cat ASCII arted frame for menu
    Get-Content C:\SCDOS\.\ascii\c2.txt
}

# Define the function to process user input
function Process-Input
{
    $input = Read-Host " [Select Input Value]"
    switch ($input)
    {
        "1" { AME }
        "2" { Power Tools }
        "3" { OptiFiX }
        "4" { Winstall }
        "5" { Misc }
        "R" { README }
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
    Write-Host "OPTI"
    # Add your code here
    cd C:\Shell
    .\3.ps1
    Pause
}

# Define the function for option 4
function Option3
{
    Write-Host "444 winstall"
    # Add your code here
    echo "4"
    .\3.ps1
    Pause
}

# Define the function for option 5
function Option3
{
    Write-Host "Misc"
    # Add your code here
    echo "5"
    .\3.ps1
    Pause
}



# Define the function for option R
function README
{
    Write-Host "README"
    # Add your code here
    echo "R"
    .\3.ps1
    Pause
}



# Define the function to pause the script
function Pause
{
    Read-Host " Press Enter to continue "
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

