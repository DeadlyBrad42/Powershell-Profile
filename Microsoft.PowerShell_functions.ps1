################################################################################
## Functions
################################################################################

# Custom prompt
#   References:
#    * https://gist.github.com/branneman/9660173
function prompt
{
    # Color "configuration"
    #   Give `[enum]::GetValues([System.ConsoleColor]) | Foreach-Object {Write-Host $_ -ForegroundColor $_ }` a try if you want to see your options
    $colorForegroundPrimary = "White"
    $colorForegroundSecondary = "Gray"
    $colorBackgroundBanner = "DarkBlue"
    $colorHighlight = "DarkYellow" # used for the adminSymbol
    $colorGitSymbol = "DarkGray"
    $colorGitChangeIndicator = "DarkGreen"
    $colorGitPushes = "Green"
    $colorGitPulls = "Red"
    $colorPathSeperatorArrow = "DarkGreen"

    # Grab current location
    $location = $(Get-Location).Path

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
    Write-Host (" [ ") -nonewline -foregroundcolor $colorForegroundSecondary -backgroundcolor $colorBackgroundBanner
    Write-Host ($userNameDisplay) -nonewline -foregroundcolor $colorForegroundPrimary -backgroundcolor $colorBackgroundBanner
    Write-Host ($userAdminDisplay) -nonewline -foregroundcolor $colorHighlight -backgroundcolor $colorBackgroundBanner
    Write-Host (" @") -nonewline -foregroundcolor $colorForegroundSecondary  -backgroundcolor $colorBackgroundBanner
    Write-Host ($machineNameDisplay) -nonewline -foregroundcolor $colorForegroundPrimary -backgroundcolor $colorBackgroundBanner
    Write-Host (" ] ") -nonewline -foregroundcolor $colorForegroundSecondary -backgroundcolor $colorBackgroundBanner

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
                $git_pushesDisplay = " ↑" + $matches[1]
            }

            if ($_ -match "behind (\d+)") {
                $git_pullsDisplay = " ↓" + $matches[1]
            }
        }

        $git_changesDisplay = ""
        if ($git_changeCount -gt 0) {
            $git_changesDisplay = "•"
        }

        # Calculate length of displays (cleaner to just build the strings & test length)
        $leftCharCount = " [ $userNameDisplay$userAdminDisplay @$machineNameDisplay ] ".length
        $rightCharCount = "[ Ѱ$($git_changesDisplay) $($git_branchName)$($git_pushesDisplay)$($git_pullsDisplay) ] ".length
        $middleCharCount = $ui.WindowSize.Width - ($leftCharCount + $rightCharCount)

        # Write spaces for padding, so that the display is right-aligned
        Write-Host (" " * $middleCharCount) -nonewline

        # Actually output the git display
        Write-Host ("[ ") -nonewline -foregroundColor $colorForegroundSecondary
        Write-Host ("Ѱ") -nonewline -foregroundcolor $colorGitSymbol
        Write-Host ($git_changesDisplay) -nonewline -foregroundcolor $colorGitChangeIndicator
        Write-Host (" $git_branchName") -nonewline -foregroundColor $colorForegroundPrimary
        Write-Host ($git_pushesDisplay) -nonewline -foregroundColor $colorGitPushes
        Write-Host ($git_pullsDisplay) -nonewline -foregroundColor $colorGitPulls
        Write-Host (" ] ") -nonewline  -foregroundColor $colorForegroundSecondary
    } else {
        # No alternate display, just send a newline
        Write-Host ("")
    }

    # If the path display takes up the majority of the terminal width, place the cursor on next line
    $pathCharCount = "»$($location)» ".length
    $pathLineLengthPercentage = $pathCharCount / $ui.WindowSize.Width
    Write-Host ("»") -nonewline -foregroundcolor $colorPathSeperatorArrow
    Write-Host ($location) -nonewline -foregroundColor $colorForegroundPrimary
    if ($pathLineLengthPercentage -gt 0.60) {
        Write-Host ("")
    }
    Write-Host ("»") -nonewline -foregroundcolor $colorPathSeperatorArrow

    return " "
}

# Register an event when the session is exited
Register-EngineEvent PowerShell.Exiting –Action {
    Test-Exit
    Start-Sleep -s 1
} | Out-Null # This command outputs stuff, so this throws it away

Function Test-Exit {
    $terminalWidth =$ui.WindowSize.Width

    if ($terminalWidth -gt 75) {
        Write-Host ('')
        Write-Host ('')
        Write-Host ('  .d8888b.  8888888888 8888888888      Y88b   d88P  .d88888b.  888     888 ') -foregroundcolor DarkRed
        Write-Host (' d88P  Y88b 888        888              Y88b d88P  d88P" "Y88b 888     888 ') -foregroundcolor DarkRed
        Write-Host ('  "Y888b.   8888888    8888888            Y888P    888     888 888     888 ') -foregroundcolor Red
        Write-Host ('     "Y88b. 888        888                 888     888     888 888     888 ') -foregroundcolor Red
        Write-Host ('       "888 888        888                 888     888     888 888     888 ') -foregroundcolor DarkYellow
        Write-Host (' Y88b  d88P 888        888                 888     Y88b. .d88P Y88b. .d88P ') -foregroundcolor DarkYellow
        Write-Host ('  "Y8888P"  8888888888 8888888888          888      "Y88888P"   "Y88888P"  ') -foregroundcolor Yellow
        Write-Host ('')
        Write-Host ('  .d8888b.  8888888b.     d8888  .d8888b.  8888888888                      ') -foregroundcolor Yellow
        Write-Host (' d88P  Y88b 888   Y88b   d88888 d88P  Y88b 888                             ') -foregroundcolor Green
        Write-Host ('  "Y888b.   888   d88P d88P 888 888        8888888                         ') -foregroundcolor Green
        Write-Host ('     "Y88b. 8888888P" d88P  888 888        888                             ') -foregroundcolor DarkGreen
        Write-Host ('       "888 888      d88P   888 888    888 888                             ') -foregroundcolor DarkGreen
        Write-Host (' Y88b  d88P 888     d8888888888 Y88b  d88P 888                             ') -foregroundcolor Blue
        Write-Host ('  "Y8888P"  888    d88P     888  "Y8888P"  8888888888                      ') -foregroundcolor Blue
        Write-Host ('')
        Write-Host ('  .d8888b.   .d88888b.  888       888 888888b.    .d88888b. Y88b   d88P    ') -foregroundcolor Cyan
        Write-Host (' d88P  Y88b d88P" "Y88b 888   o   888 888  "88b  d88P" "Y88b Y88b d88P     ') -foregroundcolor Cyan
        Write-Host (' 888        888     888 888 d888b 888 8888888K.  888     888   Y888P       ') -foregroundcolor DarkCyan
        Write-Host (' 888        888     888 888d88888b888 888  "Y88b 888     888    888        ') -foregroundcolor DarkCyan
        Write-Host (' 888    888 888     888 88888P Y88888 888    888 888     888    888        ') -foregroundcolor Magenta
        Write-Host (' Y88b  d88P Y88b. .d88P 8888P   Y8888 888   d88P Y88b. .d88P    888        ') -foregroundcolor DarkMagenta
        Write-Host ('  "Y8888P"   "Y88888P"  888P     Y888 8888888P"   "Y88888P"     888        ') -foregroundcolor DarkMagenta
        Write-Host ('')
        Write-Host ('')
    } else {
        Write-Host ('')
        Write-Host ('')
        Write-Host ('  SEE') -foregroundcolor Red -nonewline
        Write-Host (' YOU') -foregroundcolor DarkYellow -nonewline
        Write-Host (' SPACE') -foregroundcolor DarkGreen -nonewline
        Write-Host (' COW') -foregroundcolor Cyan -nonewline
        Write-Host ('BOY') -foregroundcolor DarkMagenta -nonewline
        Write-Host ('')
        Write-Host ('')
    }
}

Function Test-Warn {
    $terminalWidth =$ui.WindowSize.Width

    $warningMessage = ' ▲ Warning! '
    $warningDividerChar = '╲'
    $warningDividerCharLength = [Math]::Floor(($terminalWidth - $warningMessage.length) / 2)

    Write-Host ($warningDividerChar * $warningDividerCharLength) -foregroundcolor DarkYellow -backgroundcolor Black -nonewline
    Write-Host ($warningMessage) -foregroundcolor DarkYellow -backgroundcolor Black -nonewline
    Write-Host ($warningDividerChar * $warningDividerCharLength) -foregroundcolor DarkYellow -backgroundcolor Black -nonewline
}

# Tests color output in PS
# From http://stackoverflow.com/a/20588680
function Test-Colors( ) {
  $colors = [Enum]::GetValues( [ConsoleColor] )
  $max = ($colors | ForEach-Object { "$_ ".Length } | Measure-Object -Maximum).Maximum
  foreach( $color in $colors ) {
    Write-Host (" {0,2} {1,$max} " -f [int]$color,$color) -NoNewline
    Write-Host "$color" -Foreground $color
  }
}

Function Reload-Powershell {
    # Reload the profile & path variable (from: https://stackoverflow.com/a/31845512)
    . $profile
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Get Uptime
function Get-Uptime {
   $os = Get-WmiObject win32_operatingsystem
   $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
   $Display = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes"
   Write-Output $Display
}

# Get Line of Code
function Lines-of-Code ($filetypes) # filetypes like `*.cs,*.json`
{
    # Only counts lines with code, *not blank lines*
    $resultFiletypes = "type $filetypes"
    if ($null -eq $filetypes)
    {
        Write-Output "Counting all lines from all filetypes. You can change this by supplying a filetype argument like *.cs,*.json"
        $resultFiletypes = "all types"
    }
    $resultCount = (dir -include $filetypes -recurse | select-string .).Count
    Write-Output "Counted $resultCount lines in files of $resultFiletypes."
}
Set-Alias LoC Lines-of-Code

# Start Sublime
function Sublime
{
    & "C:\Program Files\Sublime Text\sublime_text.exe" $args
}

# Get Uptime
function Get-Uptime {
   $os = Get-WmiObject win32_operatingsystem
   $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
   $Display = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes"
   Write-Output $Display
}

# Start a Google search
function Google ($search) {
    $url = "https://www.google.com/#q=" + $search
    Start-Process $url
}

# Pipeline-able Rot13
function Rot13 { param ([parameter(ValueFromPipeline=$True)][string] $in)
    $table = @{}
    for ($i = 0; $i -lt 52; $i++) {
        $table.Add(
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"[$i],
            "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"[$i])
    }

    $out = New-Object System.Text.StringBuilder
    $in.ToCharArray() | ForEach-Object {
        $char = if ($table.ContainsKey($_)) {$table[$_]} else {$_}
        $out.Append($char) | Out-Null
    }
    Write-Output $out.ToString()
}

# ¡uʍop-ǝpısdn ʇxǝʇ ɹnoʎ dı|ɟ
function Flip-Text { param ([parameter(ValueFromPipeline=$True)][string] $in)
    $table = New-Object Collections.Hashtable ([StringComparer]::CurrentCulture)
    $table.Add([char]'a', [char]0x0250)
    $table.Add([char]'b', [char]'q')
    $table.Add([char]'c', [char]0x0254)
    $table.Add([char]'d', [char]'p')
    $table.Add([char]'e', [char]0x01DD)
    $table.Add([char]'f', [char]0x025F)
    $table.Add([char]'g', [char]0x0183)
    $table.Add([char]'h', [char]0x0265)
    $table.Add([char]'i', [char]0x0131)
    $table.Add([char]'j', [char]0x027E)
    $table.Add([char]'k', [char]0x029E)
    $table.Add([char]'l', [char]'|')
    $table.Add([char]'m', [char]0x026F)
    $table.Add([char]'n', [char]'u')
    $table.Add([char]'o', [char]'o')
    $table.Add([char]'p', [char]'d')
    $table.Add([char]'q', [char]'b')
    $table.Add([char]'r', [char]0x0279)
    $table.Add([char]'s', [char]'s')
    $table.Add([char]'t', [char]0x0287)
    $table.Add([char]'u', [char]'n')
    $table.Add([char]'v', [char]0x028C)
    $table.Add([char]'w', [char]0x028D)
    $table.Add([char]'x', [char]'x')
    $table.Add([char]'y', [char]0x028E)
    $table.Add([char]'z', [char]'z')
    $table.Add([char]'A', [char]0x0250)
    $table.Add([char]'B', [char]'q')
    $table.Add([char]'C', [char]0x0254)
    $table.Add([char]'D', [char]'p')
    $table.Add([char]'E', [char]0x01DD)
    $table.Add([char]'F', [char]0x025F)
    $table.Add([char]'G', [char]0x0183)
    $table.Add([char]'H', [char]0x0265)
    $table.Add([char]'I', [char]0x0131)
    $table.Add([char]'J', [char]0x027E)
    $table.Add([char]'K', [char]0x029E)
    $table.Add([char]'L', [char]'|')
    $table.Add([char]'M', [char]0x026F)
    $table.Add([char]'N', [char]'u')
    $table.Add([char]'O', [char]'o')
    $table.Add([char]'P', [char]'d')
    $table.Add([char]'Q', [char]'b')
    $table.Add([char]'R', [char]0x0279)
    $table.Add([char]'S', [char]'s')
    $table.Add([char]'T', [char]0x0287)
    $table.Add([char]'U', [char]'n')
    $table.Add([char]'V', [char]0x028C)
    $table.Add([char]'W', [char]0x028D)
    $table.Add([char]'X', [char]'x')
    $table.Add([char]'Y', [char]0x028E)
    $table.Add([char]'Z', [char]'z')
    $table.Add([char]'.', [char]0x02D9)
    $table.Add([char]'[', [char]']')
    #$table.Add([char]'\'', [char]',')
    #$table.Add([char]',', [char]'\'')
    $table.Add([char]'(', [char]')')
    $table.Add([char]'{', [char]'}')
    $table.Add([char]'?', [char]0x00BF)
    $table.Add([char]'!', [char]0x00A1)
    $table.Add([char]'<', [char]'>')
    $table.Add([char]'_', [char]0x203E)
    $table.Add([char]' ', [char]' ')

    $out = New-Object System.Text.StringBuilder
    $in.ToCharArray() | ForEach-Object {
        $char = if ($table.ContainsKey($_)) {$table[$_]} else {$_}
        $out.Append($char) | Out-Null
    }

    # Reverse string and print
    $out = $out.ToString()
    $out = -join $out[-1..-$out.Length]
    Write-Output $out
}

function Fuck-You { param ([parameter(ValueFromPipeline=$True)][string] $in)
    try
    {
        Stop-Process -processname $in -ErrorAction Stop
        $tableFlipGuy = "(╯°□°）╯︵"
        Write-Host " $tableFlipGuy $(Flip-Text $in)"
    }
    catch
    {
        Write-Host "Nothin' to kill here."
    }
}

function Switch-To-Explorer {
    explorer .
    exit
}
