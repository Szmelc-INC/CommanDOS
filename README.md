# CommanDOS 2.0
> Szmelc Commander for Windows (XP,7,10,11) [x86_64] \
![coverage](https://img.shields.io/badge/[Core]-49%25-green)

---

# Setup
## Installation:
Copy & paste into powershell:
```ps1
irm https://raw.githubusercontent.com/Szmelc-INC/CommanDOS/refs/heads/2.0/install.ps1 | iex
```

---

# Usage
- Install/Update CommanDOS with Powershell command `install.ps1` (It will create path `C:\CommanDOS`, download contents of this repo there, and create a Desktop shortcut for `main.ps1`
- Main script `main.ps1`, lists all configs from `menu/*.conf` to select, then opens up interactive menu from specified `.conf`
[.conf structure]
```conf
Entry Name : command to execute
Entry 2 : command2
```

# Screenshots
![image](https://github.com/user-attachments/assets/94c769f3-70ad-4126-837d-eae712fc8cbc)
