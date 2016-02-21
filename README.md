# Powershell-Profile
My Powershell profile scripts. Mostly my prompt and various helper functions of indeterminate usefulness. Also includes a provisioning script that _almost_ (but not quite!) works.

## Getting Started
1. Open a new Powershell window and type `cd ~/Documents/WindowsPowerShell` to move to the default profile directory for Powershell
2. Clone the repo into the current directory by typing `git clone git@github.com:DeadlyBrad42/Powershell-Profile.git .`. The period at the end is what tells Git to not create a new subdirectory for the project.
3. That's it! Restart Powershell and the new functions will be available to you.
4. As an optional step, if you're going to be changing the _Microsoft.PowerShell_warppipes.ps1_ file, you'll want to run `git update-index --no-assume-unchanged Microsoft.PowerShell_warppipes.ps1` to ignore any further changes to the file. Don't push anything personal or unique to you up to GitHub!

## `//TODO`
* The provision stuff doesn't quite work. Turns out installing software on Windows (automatically or otherwise) is just kind of a pain. While Chocolatey and Boxstarter are promising projects, I don't think I'd trust any script that claims to automatically provision a box at this point.
* I need to better organize my functions but ¯\\_(ツ)_/¯

## License
Do whatever you want! I'm not responsible for anything that blows up.
