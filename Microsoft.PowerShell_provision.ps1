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

    Write-Host ""
    Write-Host ""

    Write-Host "All finished! Install & provision took " $elapsedTime " seconds."

    Write-Host ""
    Write-Host ""
}

Function Provision-New-Box--InstallPM
{
    Write-Host "Installing Scoop package manager ..."
    iwr -useb get.scoop.sh | iex
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
    scoop install discord                   # Discord
    scoop install vscode                    # VS Code
    scoop install sublime-text              # Sublime
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

    Write-Host "[ ]  OneNote  [Microsoft.Office.OneNote]"
    Write-Host "[ ]  To Do  [Microsoft.Todos]"
    Write-Host "[ ]  Minecraft for Windows 10  [Microsoft.MinecraftUWP]"
    Write-Host "[ ]  Slack  [91750D7E.Slack]"
    Write-Host "[ ]  Paint.net [dotPDNLLC.paint.net]"
    Write-Host "[ ]  Simplenote [22490Automattic.Simplenote]"
    Write-Host "[ ]  Windows Terminal [WindowsTerminalDev]"
    Write-Host "[ ]  File Manager [Microsoft.WindowsFileManager]"

    Write-Host "Well, the was awkward. Anyways..."
    Write-Host "... done!"
    Write-Host ""
}
