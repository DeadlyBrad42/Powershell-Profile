################################################################################
## Functions
################################################################################

# Custom prompt
# Modified (heavily) from https://gist.github.com/branneman/9660173
function prompt
{
    $leftCharCount = 0
    $middleCharCount = 0
    $rightCharCount = 0

    # Grab current git branch
    $isGitRepo = ""
    if(Test-Path .git) {
        $isGitRepo = "yeah"
    }

    # Grab current location
    $location = $(get-location).Path;

    Write-Host ("")
    Write-Host (" [ ") -nonewline -foregroundcolor White -backgroundcolor DarkBlue
    $leftCharCount += 3
    Write-Host ([Environment]::UserName) -nonewline -foregroundcolor White -backgroundcolor DarkBlue
    $leftCharCount += [Environment]::UserName.length
    if ($isAdmin) {
        Write-Host ("†") -nonewline -foregroundcolor DarkYellow -backgroundcolor DarkBlue
        $leftCharCount += 1
    }
    Write-Host (" @") -nonewline -foregroundcolor Gray -backgroundcolor DarkBlue
    $leftCharCount += 2
    Write-Host ([System.Net.Dns]::GetHostName()) -nonewline -foregroundcolor White -backgroundcolor DarkBlue
    $leftCharCount += [System.Net.Dns]::GetHostName().length
    Write-Host (" ] ") -nonewline -foregroundcolor White -backgroundcolor DarkBlue
    $leftCharCount += 3
    # Finally removed the fade: Too many rendering issues
    #Write-Host ("▓▓▒▒░░") -nonewline -foregroundcolor DarkBlue -backgroundcolor Black
    #$leftCharCount += 6

    if ($isGitRepo) {
        # Grab current branch
        $git_branchName = "";
        git branch | foreach {
            if ($_ -match "^\* (.*)") {
                $git_branchName += $matches[1]
            }
        }

        # Check if workspace has changes
        $git_changes = 0
        $git_changesDisplay = ""
        git status --porcelain | foreach {
            $git_changes++
        }
        if ($git_changes -gt 0) {
            $git_changesDisplay = "•"
        }

        # Check if pushes or pulls available
        $git_pushes = ""
        $git_pulls = ""
        git status -sb | foreach {
            if ($_ -match "ahead (\d+)") {
                $git_pushes = " ↑" + $matches[1]
            }
            if ($_ -match "behind (\d+)") {
                $git_pulls = " ↓" + $matches[1]
            }
        }

        # Calculate length of git display (by making a new string)
        $rightCharCount = "[ Ѱ$($git_changesDisplay) $($git_branchName)$($git_pushes)$($git_pulls) ] ".length

        # Write spaces for padding, so that the display is right-aligned
        # "4" is a magic number, seems like somethng changed with the way Powershell renders special characters like the "gradient" boxes used above ¯\_(ツ)_/¯
        $middleCharCount = $ui.WindowSize.Width - ($leftCharCount + $rightCharCount) #- 4
        for ($i=1; $i -le $middleCharCount; $i++)
        {
            Write-Host (" ") -nonewline
        }

        # Actually output the git display
        Write-Host ("[ ") -nonewline
        Write-Host ("Ѱ") -nonewline -foregroundcolor DarkGray
        Write-Host ($git_changesDisplay) -nonewline -foregroundcolor DarkGreen
        Write-Host (" $git_branchName") -nonewline
        Write-Host ("$git_pushes") -nonewline -foregroundColor Green
        Write-Host ("$git_pulls") -nonewline -foregroundColor Red
        Write-Host (" ] ") -nonewline
    } else {
        # No alternate display, just send a newline
        Write-Host ("")
    }

    Write-Host ("»") -nonewline -foregroundcolor DarkGreen
    Write-Host ($location) -nonewline
    Write-Host ("»") -nonewline -foregroundcolor DarkGreen

    return " "
}

# Register an event when the session is exited
Register-EngineEvent PowerShell.Exiting –Action {
    Write-Host ('')
    Write-Host ('')
    Write-Host ('  .d8888b.  8888888888 8888888888      Y88b   d88P  .d88888b.  888     888 ') -foregroundcolor DarkRed
    Write-Host (' d88P  Y88b 888        888              Y88b d88P  d88P" "Y88b 888     888 ') -foregroundcolor DarkRed
    Write-Host ('  "Y888b.   8888888    8888888            Y888P    888     888 888     888 ') -foregroundcolor Red
    Write-Host ('     "Y88b. 888        888                 888     888     888 888     888 ') -foregroundcolor Red
    Write-Host ('       "888 888        888                 888     888     888 888     888 ') -foregroundcolor DarkYellow
    Write-Host (' Y88b  d88P 888        888                 888     Y88b. .d88P Y88b. .d88P ') -foregroundcolor DarkYellow
    Write-Host ('  "Y8888P"  8888888888 8888888888          888      "Y88888P"   "Y88888P"  ') -foregroundcolor Yellow
    Write-Host ('  .d8888b.  8888888b.     d8888  .d8888b.  8888888888                      ') -foregroundcolor Yellow
    Write-Host (' d88P  Y88b 888   Y88b   d88888 d88P  Y88b 888                             ') -foregroundcolor Green
    Write-Host ('  "Y888b.   888   d88P d88P 888 888        8888888                         ') -foregroundcolor Green
    Write-Host ('     "Y88b. 8888888P" d88P  888 888        888                             ') -foregroundcolor DarkGreen
    Write-Host ('       "888 888      d88P   888 888    888 888                             ') -foregroundcolor DarkGreen
    Write-Host (' Y88b  d88P 888     d8888888888 Y88b  d88P 888                             ') -foregroundcolor Blue
    Write-Host ('  "Y8888P"  888    d88P     888  "Y8888P"  8888888888                      ') -foregroundcolor Blue
    Write-Host ('  .d8888b.   .d88888b.  888       888 888888b.    .d88888b. Y88b   d88P    ') -foregroundcolor Cyan
    Write-Host (' d88P  Y88b d88P" "Y88b 888   o   888 888  "88b  d88P" "Y88b Y88b d88P     ') -foregroundcolor Cyan
    Write-Host (' 888        888     888 888 d888b 888 8888888K.  888     888   Y888P       ') -foregroundcolor DarkCyan
    Write-Host (' 888        888     888 888d88888b888 888  "Y88b 888     888    888        ') -foregroundcolor DarkCyan
    Write-Host (' 888    888 888     888 88888P Y88888 888    888 888     888    888        ') -foregroundcolor Magenta
    Write-Host (' Y88b  d88P Y88b. .d88P 8888P   Y8888 888   d88P Y88b. .d88P    888        ') -foregroundcolor DarkMagenta
    Write-Host ('  "Y8888P"   "Y88888P"  888P     Y888 8888888P"   "Y88888P"     888        ') -foregroundcolor DarkMagenta
    Write-Host ('')
    Write-Host ('')
    Start-Sleep -s 1
} > null # This command outputs stuff, so this throws it away

Function Test-Warn {
    Write-Host ("╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲ ▲ Warning! ╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲╲") -foregroundcolor DarkYellow -backgroundcolor Black
}

# Do some registry magic to import my personal color scheme (based on Base16)
Function Reset-Theme{
    # Script based on http://poshcode.org/2220
    Set-StrictMode -Version Latest
    Push-Location
    Set-Location HKCU:\Console

    # from: http://www.leeholmes.com/blog/2008/06/01/powershells-noble-blue/
    # New-Item ".\%SystemRoot%_system32_WindowsPowerShell_v1.0_powershell.exe"
    Set-Location ".\%SystemRoot%_system32_WindowsPowerShell_v1.0_powershell.exe"

    # Colors - They're stored as little-endian because why not I guess
    $colors = @(
        0x00151515, 0x0097814C, 0x003B8B72, 0x00808000,
        0x0024238E, 0x0081578C, 0x004584D2, 0x00D0D0D0,
        0x00505050, 0x00AAB575, 0x0059A990, 0x00B59F6A,
        0x004241AC, 0x009F75AA, 0x0075BFF4, 0x00F5F5F5
    )
    for ($index = 0; $index -lt $colors.Length; $index++) {
        $keyExists = Get-Item -LiteralPath . -ErrorAction SilentlyContinue
        if(-Not $keyExists) {
            #Write-Host "key does not exist"
            New-ItemProperty . -Name ("ColorTable" + $index.ToString("00")) -PropertyType DWORD -Value $colors[$index]
        }
        Else {
            #Write-Host "key exists, will be re-written"
            Set-itemProperty . -Name ("ColorTable" + $index.ToString("00")) -Value $colors[$index]
        }
    }

    # New-ItemProperty . FaceName -PropertyType STRING -Value "Consolas"
    Pop-Location

    #TODO: Automate
    Write-Host "To propogate these changes, you need to manually re-create all shortcuts to PowerShell"
}

# Tests color output in PS
# From http://stackoverflow.com/a/20588680
function Test-Colors( ) {
  $colors = [Enum]::GetValues( [ConsoleColor] )
  $max = ($colors | foreach { "$_ ".Length } | Measure-Object -Maximum).Maximum
  foreach( $color in $colors ) {
    Write-Host (" {0,2} {1,$max} " -f [int]$color,$color) -NoNewline
    Write-Host "$color" -Foreground $color
  }
}

# Start Sublime
function Sublime
{
    & "C:\Program Files\Sublime Text 2\sublime_text.exe" $args
}

# Get Line of Code
function Lines-of-Code ($filetypes) # filetypes like `*.cs,*.json`
{
    # Only counts lines with code, *not blank lines*
    $resultFiletypes = "type $filetypes"
    If($filetypes -eq $null)
    {
        Write-Output "Counting all lines from all filetypes. You can change this by supplying a filetype argument like *.cs,*.json"
        $resultFiletypes = "all types"
    }
    $resultCount = (dir -include $filetypes -recurse | select-string .).Count
    Write-Output "Counted $resultCount lines in files of $resultFiletypes."
}
Set-Alias LoC Lines-of-Code

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
    start $url
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
    $in.ToCharArray() | %{
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
    $in.ToCharArray() | %{
        $char = if ($table.ContainsKey($_)) {$table[$_]} else {$_}
        $out.Append($char) | Out-Null
    }

    # Reverse string and print
    $out = $out.ToString();
    $out = -join $out[-1..-$out.Length]
    Write-Output $out
}

function Fuck-You { param ([parameter(ValueFromPipeline=$True)][string] $in)
    try
    {
        kill -processname $in -ErrorAction Stop
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
