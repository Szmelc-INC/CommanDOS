# CommanDOS [v1.2]
> Szmelc Commander 2.0 for Windows (XP,7,10,11) [x86_64] \
![coverage](https://img.shields.io/badge/[Core]-49%25-green)

---

# Setup
## Installation / Update:
Copy & paste into Powershell (as Administrator):
```ps1
irm https://raw.githubusercontent.com/Szmelc-INC/CommanDOS/refs/heads/2.0/install.ps1 | iex
```

---

# Usage
- Install/Update CommanDOS with Powershell command `install.ps1` (It will create path `C:\CommanDOS`, download contents of this repo there, and create a Desktop shortcut for `main.ps1`
- Main script `main.ps1`, lists all configs from `menu/*.conf` to select, then opens up interactive menu from specified `.conf`

### [.conf]
`.conf` structure
```conf
Entry Name : command to execute
Entry 2 : command2
```
Example `.conf`
```conf
Open Command Prompt : start cmd
Open PowerShell : start powershell
System Information : systeminfo | more
Task Manager : Start-Process taskmgr
Device Manager : Start-Process devmgmt.msc
Network Connections : Start-Process ncpa.cpl
Control Panel : Start-Process control
```

# Screenshots
![image](https://github.com/user-attachments/assets/c0268137-93b0-4a11-be30-89e302873dad)

![image](https://github.com/user-attachments/assets/94c769f3-70ad-4126-837d-eae712fc8cbc)
