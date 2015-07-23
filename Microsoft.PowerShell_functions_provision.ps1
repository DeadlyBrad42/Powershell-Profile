################################################################################
## Provisioning Function
################################################################################

# Installs primary software using a GitHub Gist
Function Provision-Box-Software
{
    Write-Host "////////////////////////////////////////////////////////////////////////////////"
    Write-Host "                        Provisioning new box build-out"
    Write-Host ""
    Write-Host "   This script will install software and programs using the Chocolatey package"
    Write-Host "   manager and Boxstarter automation tool. Both are community-built tools that"
    Write-Host "   require some level of trust before use. If this doesn't sound like what you"
    Write-Host "   want to do you should exit now."
    Write-Host ""
    Write-Host "   If you would like to customize what gets installed, exit now and open the"
    Write-Host "   install script and comment-out (or add) packages to your liking. Additional"
    Write-Host "   information is available at the Boxstarter and Chocolatey websites."
    Write-Host ""
    Write-Host "   This script is executing from " $PSScriptRoot "."
    Write-Host "////////////////////////////////////////////////////////////////////////////////"

    Write-Host ""
    Write-Host "Press any key to continue ..."
    $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Host ""

    # Uses Boxstarter (http://boxstarter.org/)
    # Install script Gist located here: https://gist.github.com/DeadlyBrad42/2782ac9b5a5a5d48fd05
    # If you want to use your own script, upload it as a Gist and insert your own Raw URL below
    START http://boxstarter.org/package/url?https://gist.githubusercontent.com/DeadlyBrad42/2782ac9b5a5a5d48fd05/raw/a97208596f88270b1fc990225d7a27611234d473/Provision.ps1
}

# Installs npm packages that I like
Function Provision-Box-Npm
{
    # Install npm packages
    npm install -g http-server
    npm install -g json-server
    npm install -g grunt-cli
    npm install -g nodemon
    npm install -g typescript
    npm install -g less
    npm install -g yo
}

# Manual Installs
# Install Office
# Install Winamp
# Install Soluto                    [https://www.soluto.com/]
# Install Bitcoin                   [https://bitcoin.org/en/]
# Install Namecoin                  [https://namecoin.info/]
# Install Veracrypt                 [https://veracrypt.codeplex.com/]
# Install PowerShell Server         [http://www.powershellserver.com/]
# Install Google Music Manager      [https://support.google.com/googleplay/answer/1229970?hl=en]
# Install Pushbullet                [https://www.pushbullet.com/]
# Install Minecraft                 [https://minecraft.net/]
# Install Factorio                  [https://www.factorio.com/]
# Install Xsplit                    [https://www.xsplit.com/download]
