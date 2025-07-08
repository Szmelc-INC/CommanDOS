# CommanDOS [v1.3]
> ***A Power User Toolkit 4 Powershell autorstwa Szmelc*** \
> ***- CommanDOS*** to interaktywne narzędzie CLI/TUI dla użytkowników Windows, stworzone w PowerShell przez Szmelc.INC. \
Umożliwia ono tworzenie własnych menu operacyjnych na podstawie plików .conf, które umożliwiają uruchamianie różnych programów, poleceń lub narzędzi administracyjnych jednym kliknięciem. \
> Szmelc Commander 2.0 dla Windows (XP,7,10,11) [x86_64] \
![coverage](https://img.shields.io/badge/[Core]-49%25-green)

---

```
                                                           __             
  ,- _~.                                     -_____      ,-||-,     -_-/  
 (' /|                             _           ' | -,   ('|||  )   (_ /   
((  ||    /'\\ \\/\\/\\ \\/\\/\\  < \, \\/\\  /| |  |` (( |||--)) (_ --_  
((  ||   || || || || || || || ||  /-|| || ||  || |==|| (( |||--))   --_ ) 
 ( / |   || || || || || || || || (( || || || ~|| |  |,  ( / |  )   _/  )) 
  -____- \\,/  \\ \\ \\ \\ \\ \\  \/\\ \\ \\  ~-____,    -____-   (_-_-
                                             (
```

---

# Konfiguracja
## Instalacja/Aktualizacja:
Skopiuj i wklej do Powershell (jako Administrator):

```ps1
irm https://raw.githubusercontent.com/Szmelc-INC/CommanDOS/refs/heads/2.0/install.ps1 | iex
```

---

# Użycie
- Zainstaluj/aktualizuj CommandOS za pomocą polecenia Powershell `install.ps1` (Utworzy ono ścieżkę `C:\CommanDOS`, pobierze zawartość tego repozytorium i utworzy skrót na pulpicie dla `main.ps1`
- Główny skrypt `main.ps1`, wyświetla wszystkie konfiguracje z `menu/*.conf` do wyboru, a następnie otwiera interaktywne menu z określonego `.conf`

### [.conf]
`.conf` struktura
```conf
Nazwa wpisu: polecenie do wykonania
Wpis 2: command2
```
Przykład `.conf`
```conf
Otwórz wiersz poleceń: start cmd
Otwórz PowerShell: start powershell
Informacje o systemie: systeminfo | more
Menedżer zadań: Start-Process taskmgr
Menedżer urządzeń: Start-Process devmgmt.msc
Połączenia sieciowe: Start-Process ncpa.cpl
Panel sterowania: Start-Process control
```

# Zrzuty ekranu
`Setup` - `install.ps1` \
![image](https://github.com/user-attachments/assets/c0268137-93b0-4a11-be30-89e302873dad)

`Main` - `main.ps1` + `Networking.conf / Admin.conf` \
![obraz](https://github.com/user-attachments/assets/e6cd9d88-adce-4fd8-8d4f-f8f18999bcdf) ![obraz](https://github.com/user-attachments/assets/791ac33e-5668-4a96-9594-66bc411d48ab)

`Różne` \
![obraz](https://github.com/user-attachments/assets/94c769f3-70ad-4126-837d-eae712fc8cbc)
