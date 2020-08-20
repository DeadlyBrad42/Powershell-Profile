################################################################################
## General PowerShell Stuff
################################################################################
param([String]$clientType)
$ui = (Get-Host).UI.RawUI
$ui.WindowTitle = "POWASHELL"

# Determine if Powershell is running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$PROFILEPATH = Split-Path $profile -Parent

# I like starting my terminal in my B: drive, rather than $home
# Idk a better way to do this 😖
if ($(pwd).Path -eq $home) {
    Set-Location B:
}

If(-Not $clientType) {
    Write-Host ("   | (• ◡•)|╯") -nonewline -foregroundcolor White
    Write-Host ("╰(❍ᴥ❍ʋ)") -nonewline -foregroundcolor Yellow
    Write-Host ("    <(Let's go kick their digital bootays!)") -nonewline
    Write-Host ("")
}

################################################################################
## Imports
################################################################################

# General Functions
. "$PSScriptRoot\Microsoft.PowerShell_functions.ps1"

# Shortcuts to other directories and network shares
. "$PSScriptRoot\Microsoft.PowerShell_warppipes.ps1"

# Functions for provisioning new systems
. "$PSScriptRoot\Microsoft.PowerShell_provision.ps1"
