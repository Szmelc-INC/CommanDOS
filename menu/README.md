A .conf file, should be formatted as:
`Menu Label : PowerShell Command`
The file will be parsed line-by-line by a custom main.ps1 launcher that uses Invoke-Expression $command to run the command.
⚠️ DO NOT use powershell -Command "..." or wrap commands in quotes. Each command must be:
A raw, valid PowerShell one-liner
Fully self-contained on one line
If user input is needed, use Read-Host "Prompt"
If multiple inputs are needed (e.g., path + user), prompt separately
If Out-GridView is used, pipe from a valid object (like Get-Process)
✅ Syntax must be clean and compatible with Invoke-Expression
✅ Prefer flat, readable one-liners
✅ Escape " only when needed (\" or `)
