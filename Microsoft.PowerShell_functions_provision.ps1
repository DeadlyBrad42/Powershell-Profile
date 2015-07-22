################################################################################
## Provisioning Functions
################################################################################

Function Provision-Box{
    echo
"////////////////////////////////////////////////////////////////////////////////
                        Provisioning new box build-out

 This script will install software and programs using the Chocolatey package
 manager. If that's not what you want to do you should exit now. If you want to
 customize what gets installed, exit now and open the script and comment-out
 anything you don't want installed.

 This script is executing from $PSScriptRoot
////////////////////////////////////////////////////////////////////////////////"

    pause


    # Install Chocolatey
    Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

    # Browsers
    choco install firefox
    choco install googlechrome

    # Development Tools
    choco install sublimetext2
    choco install visualstudiocode
    choco install visualstudiocommunity2013
    choco install androidstudio
    choco install nodejs.install
    choco install git.install
    choco install sourcetree
    choco install virtualbox
    choco install vagrant

    # NPM packages
    npm install -g http-server
    npm install -g json-server
    npm install -g grunt-cli
    npm install -g nodemon
    npm install -g typescript
    npm install -g less
    npm install -g yo

    # Game-making
    choco install blender
    choco install unity
    choco install paint.net
    choco install tiled

    # Game-playing
    choco install steam
    choco install origin

    # Misc
    choco install resophnotes
    choco install skype
    choco install qbittorrent
    choco install lastfmscrobbler
    choco install dropbox
    choco install mp3tag

    # Utilities
    choco install virtualclonedrive
    choco install imgburn
    choco install gifcam
    choco install sumatrapdf
    choco install winrar
    choco install 7zip.install
    choco install malwarebytes
    choco install ccleaner
    choco install recuva
    choco install defraggler
    choco install winmerge
    choco install windirstat
    choco install f.lux


    # Manual Installs
    # Install Office
    # Install Winamp
    # Install Soluto
    # Install Bitcoin
    # Install Namecoin
    # Install Veracrypt
    # Install Minecraft
    # Install Factorio
    # Install Xsplit
    # Install Google Music Manager
    # Install Pushbullet
}