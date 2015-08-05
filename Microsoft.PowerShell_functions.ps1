################################################################################
## Functions
################################################################################

# Do some registry magic to import my personal color scheme (based on Base16)
Function Reset-Theme{
    # Script based on http://poshcode.org/2220
    Set-StrictMode -Version Latest
    Push-Location
    Set-Location HKCU:\Console

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

    New-ItemProperty . FaceName -PropertyType STRING -Value "Consolas"
    Pop-Location

    #TODO: Automate
    Write-Host "To propogate these changes, you need to manually re-create all shortcuts to PowerShell"
}

# Start Sublime
function Sublime
{
    & "C:\Program Files\Sublime Text 2\sublime_text.exe" $args
}

# Get Line of Code
function LoC ($filetypes) # filetypes like `*.cs,*.json`
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

# Get Uptime
function Get-Uptime {
   $os = Get-WmiObject win32_operatingsystem
   $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
   $Display = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes"
   Write-Output $Display
}

# Start a Google search
function google {
    $search = $args
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
