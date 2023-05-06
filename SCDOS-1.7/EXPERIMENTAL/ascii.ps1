clear
Write-Host "cat Random ASCII Art`n"
$files = Get-ChildItem -Path "C:\Shell\ascii\" -Filter *.txt
$randomFile = Get-Random -InputObject $files
Get-Content $randomFile.FullName