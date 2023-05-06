# Define variables
$GitBashUrl = "https://github.com/git-for-windows/git/releases/download/v2.31.1.windows.1/Git-2.31.1-64-bit.exe"
$GitBashInstaller = "Git-2.31.1-64-bit.exe"

# Download Git Bash installer
Invoke-WebRequest -Uri $GitBashUrl -OutFile $GitBashInstaller

# Install Git Bash silently
& $GitBashInstaller /SILENT

# Remove Git Bash installer
Remove-Item $GitBashInstaller
