# Define variables
$GitBashUrl = "https://github.com/git-for-windows/git/releases/download/v2.31.1.windows.1/Git-2.31.1-64-bit.exe"
$GitBashInstaller = "Git-2.31.1-64-bit.exe"

# Download Git Bash installer
$Request = [System.Net.WebRequest]::Create($GitBashUrl)
$Request.Method = "GET"
$Response = $Request.GetResponse()
$Stream = $Response.GetResponseStream()
$Output = New-Object -TypeName System.IO.FileStream -ArgumentList $GitBashInstaller, Create
$Stream.CopyTo($Output)
$Output.Close()
$Stream.Close()
$Response.Close()

# Install Git Bash silently
& $GitBashInstaller /SILENT

# Remove Git Bash installer
Remove-Item $GitBashInstaller
