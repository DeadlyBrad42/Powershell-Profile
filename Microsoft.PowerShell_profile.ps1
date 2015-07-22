################################################################################
## General PowerShell stuff
################################################################################
$ui = (Get-Host).UI.RawUI
$ui.WindowTitle = "POWASHELL"

Set-Location B:


################################################################################
## Imports
################################################################################

# General Functions
. "$PSScriptRoot\Microsoft.PowerShell_functions.ps1"

# Functions for provisioning new installs
. "$PSScriptRoot\Microsoft.PowerShell_functions_provision.ps1"

# Shortcuts to other directories and network shares
. "$PSScriptRoot\Microsoft.PowerShell_warppipes.ps1"