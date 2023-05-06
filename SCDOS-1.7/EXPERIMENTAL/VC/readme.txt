HOWTO RUN SZMELC-COMMANDOS ON WINDOWS VIA POWERSHELL.EXE
- 1. Start Powershell.exe as administrator!

- 2. Locate 'Shell' directory on your C:\ Drive (create if none exists)

To allow powershell script execution, Run: 
Set-ExecutionPolicy Unrestricted

- 3. Cd into 'Shell' & ls by first running: "cd C:\Shell" then "ls"

cd C:\Shell
ls

- 4. Run below command from admin powershell.exe in any path to execute script in powershell

Start-Process powershell.exe -Verb runAs -ArgumentList "-noexit","cd 'C:\Shell\'; .\x.ps1"

Start-Process powershell.exe -Verb runAs -ArgumentList "-noexit","cd 'C:\Shell\'; .\newscript.ps1"