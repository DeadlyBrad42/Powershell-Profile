################################################################################
## General PowerShell Stuff
################################################################################
$ui = (Get-Host).UI.RawUI
$ui.WindowTitle = "POWASHELL"

$PROFILEPATH = Split-Path $profile -Parent

Set-Location B:

# Determine if Powershell is running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Host ("   | (• ͜•)|╯") -nonewline -foregroundcolor White
Write-Host ("╰(⃝ᴥ⃝ʋ)") -nonewline -foregroundcolor Yellow
Write-Host ("    <(Let's go kick their digital bootays!)") -nonewline
Write-Host ("")

################################################################################
## Imports
################################################################################

# General Functions
. "$PSScriptRoot\Microsoft.PowerShell_functions.ps1"

# Functions for provisioning new installs
. "$PSScriptRoot\Microsoft.PowerShell_functions_provision.ps1"

# Shortcuts to other directories and network shares
. "$PSScriptRoot\Microsoft.PowerShell_warppipes.ps1"