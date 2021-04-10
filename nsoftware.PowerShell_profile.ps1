# I use this file along with nsoftware's "PowerShell Server" to connect to my PC
#  from an old VT420 terminal sometimes. Suffice to say, the display doesn't
#  support some of the more "advanced" Unicode characters I use

# All Powershell Server clients should also run my profile script
. "C:\Users\Brad\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -clientType "VT420"

# Override the default prompt to better support VT420
function prompt
{
    # Grab current location
    $location = $(get-location).Path;

    # Check to see if we're in a git directory
    $isGitRepo = ""
    do {
        if (Test-Path .git) {
            $isGitRepo = "yeah"
            break
        }

        Set-Location -Path ..
    } until ((Get-Location | Split-Path) -eq "")
    Set-Location $location

    # Grab some user/domain info
    $userNameDisplay = [Environment]::UserName
    $machineNameDisplay = [System.Net.Dns]::GetHostName()
    $userAdminDisplay = ""
    if ($isAdmin) {
        $userAdminDisplay = "†"
    }

    # Output the user/domain banner
    Write-Host ("") # newline
    Write-Host (" [ $userNameDisplay$userAdminDisplay @$machineNameDisplay ] ") -nonewline

    if ($isGitRepo) {
        # Grab current branch
        $git_branchName = ""
        $git_branches = git branch
        $git_branches | ForEach-Object {
            if ($_ -match "^\* (.*)") {
                $git_branchName += $matches[1]
            }
        }

        # Check if workspace has changes
        $git_status = git status -sb
        $git_changeCount = -1 # Start at -1 to account for 1st line of `git status -sb` output
        $git_pushesDisplay = ""
        $git_pullsDisplay = ""

        $git_status | ForEach-Object {
            $git_changeCount++

            if ($_ -match "ahead (\d+)") {
                $git_pushesDisplay = " U" + $matches[1]
            }

            if ($_ -match "behind (\d+)") {
                $git_pullsDisplay = " D" + $matches[1]
            }
        }

        $git_changesDisplay = ""
        if ($git_changeCount -gt 0) {
            $git_changesDisplay = "*"
        }

        # Calculate length of displays (cleaner to just build the strings & test length)
        $leftCharCount = " [ $userNameDisplay$userAdminDisplay @$machineNameDisplay ] ".length
        $rightCharCount = "[ Y$($git_changesDisplay) $($git_branchName)$($git_pushesDisplay)$($git_pullsDisplay) ] ".length
        $middleCharCount = $ui.WindowSize.Width - ($leftCharCount + $rightCharCount)

        # Write spaces for padding, so that the display is right-aligned
        Write-Host (" " * $middleCharCount) -nonewline

        # Actually output the git display
        Write-Host ("[ Y$($git_changesDisplay) $($git_branchName)$($git_pushesDisplay)$($git_pullsDisplay) ] ") -nonewline
    } else {
        # No alternate display, just send a newline
        Write-Host ("")
    }

    Write-Host ($location) -nonewline
    Write-Host (" >") -nonewline

    return " "
}
