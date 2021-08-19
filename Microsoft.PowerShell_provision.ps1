################################################################################
## Provisioning Functions
################################################################################

Function Provision-New-Box
{
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-Not ($isAdmin)) {
        Write-Host "ERROR: Running the provision script requires Administrative privileges."
        return
    }

    Write-Host ""
    Write-Host ""
    Write-Host "╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲ ▲ Warning! ╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲" -foregroundcolor DarkYellow -backgroundcolor Black
    Write-Host ""
    Write-Host "    This script is used to provision a new box with my standard"
    Write-Host "      load-out of software, development tools, games, and utilities."
    Write-Host ""
    Write-Host "    Running this script will automatically:"
    Write-Host "        * Install software & programs using the Scoop package manager"
    Write-Host "        * Install nvm & the latest version of node"
    Write-Host "        * Create & alter registry values"
    Write-Host ""
    Write-Host "    If you are ready to begin the installation proccess, enter the phrase"
    Write-Host "      'BEGIN' at the prompt below. Otherwise, press CTRL+C to quit."
    Write-Host ""
    Write-Host "╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲" -foregroundcolor DarkYellow -backgroundcolor Black
    Write-Host ""
    Write-Host ""

    $acknowledged = 0
    do {
        Write-Host "> " -nonewline
        $acknowledged = $host.UI.ReadLine()
    } while ($acknowledged -ne "BEGIN")

    $elapsedTime = 0

    Provision-New-Box--InstallPM
    Provision-New-Box--InstallPackages--Phase1

    # Reload the profile & path variable (from: https://stackoverflow.com/a/31845512)
    . $profile
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    Provision-New-Box--InstallPackages--Phase2
    Provision-New-Box--ConfigurePackages
    Provision-New-Box--InstallWinPackages
    Provision-New-Box--ConfigurePrefs

    Write-Host ""
    Write-Host ""

    Write-Host "All finished! Install & provision took " $elapsedTime " seconds."

    Write-Host ""
    Write-Host ""
}

Function Provision-New-Box--InstallPM
{
    Write-Host "Installing Scoop package manager ..."
    Invoke-WebRequest -useb get.scoop.sh | iex
    scoop bucket add extras
    scoop bucket add games
    scoop bucket add nerd-fonts
    scoop update
    Write-Host "... done!"
    Write-Host ""
}


Function Provision-New-Box--InstallPackages--Phase1
{
    Write-Host "Installing Scoop packages ..."
    scoop install firefox                   # firefox
    # scoop install googlechrome            # googlechrome
    scoop install chromium                  # chromium
    scoop install windirstat                # windirstat
    scoop install imgburn                   # ImgBurn
    scoop install qbittorrent               # qbittorrent
    scoop install vscode                    # VS Code
    scoop install arduino                   # Arduino
    scoop install steam                     # Steam
    scoop install minecraft                 # Minecraft
    scoop install github                    # GitHub app
    scoop install postman                   # Postman
    scoop install ngrok                     # ngrok
    scoop install nvm                       # nvm, for node(s)
    scoop install xmousebuttoncontrol       # X-Mouse Button Control
    scoop install vlc                       # VLC
    scoop install handbrake                 # Handbrake
    scoop install speccy                    # speecy
    scoop install firacode                  # Fira Code font
    scoop install figlet                    # Figlet
    # scoop install mp3tag                  # Mp3tag
    Write-Host "... done!"
    Write-Host ""
}

Function Provision-New-Box--InstallPackages--Phase2
{
    Write-Host "Installing node & common global packages ..."
    nvm install latest
    nvm use latest # TODO: This command might not exist yet (https://github.com/coreybutler/nvm-windows/issues/543)
    npm install -g rimraf
    npm install -g http-server json-server
    Write-Host "... done!"
    Write-Host ""
}

Function Provision-New-Box--ConfigurePackages
{
    Write-Host "Configuring registry ..."
    # Handy examples:
    # New-Item -Path $registryPath -Force | Out-Null
    # New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null

    Push-Location


    # Show file extensions in Explorer
    Set-Location HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced
    Set-ItemProperty . HideFileExt "0"                  # 0 = show, 1 = hide

    # Disable Bing searches from the start menu
    Set-Location HKCU:\\SOFTWARE\\Policies\\Microsoft\\Windows
    New-Item -Path .\\Explorer -Force | Out-Null
    New-ItemProperty -Path .\\Explorer -Name DisableSearchBoxSuggestions -Value 1 -PropertyType DWORD -Force | Out-Null

    # Remove individual drives from explorer's lefthand pane
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\DelegateFolders\\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\DelegateFolders\\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" | Out-Null

    # Remove all the random folders from under "This PC" in explorer's lefthand pane
    # Desktop folder
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" -Recurse | Out-Null
    # Documents folder
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{d3162b92-9365-467a-956b-92703aca08af}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{d3162b92-9365-467a-956b-92703aca08af}" -Recurse | Out-Null
    # Downloads folder
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{374DE290-123F-4565-9164-39C4925E467B}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{088e3905-0323-4b02-9826-5d99428e115f}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{374DE290-123F-4565-9164-39C4925E467B}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{088e3905-0323-4b02-9826-5d99428e115f}" -Recurse | Out-Null
    # Music folder
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" | Out-Null
    # Pictures folder
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -Recurse | Out-Null
    # Videos folder
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse | Out-Null
    Remove-Item -Path "HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse | Out-Null


    Pop-Location
    Write-Host "... done!"
    Write-Host ""
}

Function Provision-New-Box--InstallWinPackages
{
    Write-Host "Installing Windows Store packages ..."
    Write-Host "ERR..."
    Write-Host "Normally, this should be called from the 'InstallPackages' step, but"
    Write-Host "The windows store doesn't yet support automated downloads. But here's the list:"

    # You can run this in an elevated command prompt to see what's currently installed:
    #   Get-AppxPackage -AllUsers | Select Name, PackageFullName
    Write-Host "[ ]  OneNote  [Microsoft.Office.OneNote]"
    Write-Host "[ ]  To Do  [Microsoft.Todos]"
    Write-Host "[ ]  Minecraft for Windows 10  [Microsoft.MinecraftUWP]"
    Write-Host "[ ]  Slack  [91750D7E.Slack]"
    Write-Host "[ ]  Paint.net  [dotPDNLLC.paint.net]"
    Write-Host "[ ]  Simplenote  [22490Automattic.Simplenote]"
    Write-Host "[ ]  Windows Terminal  [WindowsTerminalDev]"
    Write-Host "[ ]  File Manager  [Microsoft.WindowsFileManager]"
    Write-Host "[ ]  Python  [PythonSoftwareFoundation.Python.3.9]"

    Write-Host "Well, the was awkward. Anyways..."
    Write-Host "... done!"
    Write-Host ""
}

Function Provision-New-Box--ConfigurePrefs
{
    Write-Host "Configurating preferences ..."
    git config --global init.defaultBranch main
    git config --global alias.what status -sb
    git config --global alias.andthis commit --amend --no-edit
    git config --global alias.thistoo commit --amend --no-edit
    Write-Host "... done!"
    Write-Host ""
}
