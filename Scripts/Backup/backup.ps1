### backup.ps1

### Description
# This script is able to kick off multiple robocopy processes when given a
#   comma-seperated array of source directories. It also includes a mechanism to
#   output to a datetime-stamped folder name, or continously keep a remote
#   directory in-sync from a source. It can be run directly from script or from
#   Windows Task Scheduler.

### How to Use
#
# One-time run, will save in a datetime-stamped folder:
# >  ./backup.ps1 "B:,X:,C:\Users\Brad" "\\station-2e\Backup"
#
# Task-Scheduler-able way to run, will output to 'latest' folder:
# >  powershell.exe -NoProfile -NoLogo -NonInteractive -File ".\backup.ps1" "B:,X:,C:\Users\Brad" "\\station-2e\Backup" true

Param
(
  [parameter(Mandatory=$true)][string] $sources,
  [parameter(Mandatory=$true)][string] $destination,
  [parameter(Mandatory=$false)][string] $incremental = "false"
)

$dateTimeFormat = "yyyy/MM/dd HH:mm(K)"
$retryCount = 5
$retryWait = 10

$timerTotal = New-Object -TypeName System.Diagnostics.Stopwatch

# Look, I hate this, but if you try to pass a Powershell script an array of
#   strings, you're gonna have a bad time
$sourcesArray = $sources.Split(',')

# Get a fresh timestamp for the directory name
$runDate = Get-Date

Write-Host (" >> ") -nonewline -foregroundcolor "Cyan"
Write-Host ("🏁 Back up started @ $(Get-Date -Format $dateTimeFormat)")
Write-Host (" >> ") -nonewline -foregroundcolor "Cyan"
Write-Host ("🧮 Backing up the following $($sourcesArray.length) sources: $($sourcesArray -join ", ")")
Write-Host ("") # newline

$timerTotal.Start()

# Foreach provided source dir, kick off a new robocopy task to the destination
$sourcesArray | ForEach-Object {
  $source = $_.TrimEnd('\')
  $timerJob = New-Object -TypeName System.Diagnostics.Stopwatch
  $userName = ([Environment]::UserName).ToLower()
  $hostName = [System.Net.Dns]::GetHostName().ToLower()
  $destinationSourceDirectoryName = $source.replace(":", "").replace("\", "_").TrimEnd('_')

  # Determine the name of the timestamped directory
  $timestampDirectoryName = If ($incremental -match "true") { "latest" } Else { Get-Date $runDate -Format FileDateTimeUniversal }

  # Build the destination path based on the machine, source directory name, & backup type
  $destinationPath = "$destination\$userName\$hostName\$timestampDirectoryName\$destinationSourceDirectoryName"

  Write-Host (" >> ") -nonewline -foregroundcolor "Cyan"
  Write-Host ("💾 Back up for $source started @ $(Get-Date -Format $dateTimeFormat)")
  Write-Host ("") # newline

  $timerJob.Start()

  # Run the robocopy command
  Invoke-Command -ScriptBlock { robocopy `"$source`" `"$destinationPath`" /COPY:DAT /DCOPY:DAT /MIR /XJ /R:$retryCount /W:$retryWait }

  # TODO: Logging to file? Errors? Successes?
  # TODO: Excluding directories & files? RecycleBin? Configurable for blockchain directories?

  $timerJob.Stop()
  $timerJobStr = "$([Math]::Truncate([decimal]$timerTotal.Elapsed.TotalHours))h $($timerJob.Elapsed.Minutes)m $($timerJob.Elapsed.Seconds)s $($timerJob.Elapsed.Milliseconds)ms"

  Write-Host (" >> ") -nonewline -foregroundcolor "Cyan"
  Write-Host ("✅ Back up for $source completed in ${timerJobStr} (@ $(Get-Date -Format $dateTimeFormat))")
  Write-Host ("") # newline
  Write-Host ("") # newline
}

$timerTotal.Stop()
$timerTotalStr = "$([Math]::Truncate([decimal]$timerTotal.Elapsed.TotalHours))h $($timerTotal.Elapsed.Minutes)m $($timerTotal.Elapsed.Seconds)s $($timerTotal.Elapsed.Milliseconds)ms"

Write-Host ("") # newline
Write-Host (" >> ") -nonewline -foregroundcolor "Cyan"
Write-Host ("🏆 Back up finished in ${timerTotalStr} (@ $(Get-Date -Format $dateTimeFormat)")
Write-Host ("") # newline
Write-Host ("") # newline
