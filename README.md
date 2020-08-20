# Powershell-Profile
My Powershell profile scripts. This repo mostly consists of my prompt, a pile of helpful & less-than-helpful utility functions, and a provisioning script using the command-line installer [Scoop](https://scoop.sh/).

![A preview of my Powershell prompt](/assets/profile-preview.png)

## Getting Started
1. Open a new Powershell window and head into the _Documents_ folder for your current user: `cd ~/Documents/`
1. Clone this repo into a new directory named _WindowsPowerShell_: `git clone git@github.com:DeadlyBrad42/Powershell-Profile.git WindowsPowerShell`
1. That's it! Run `. $profile` to reload profile scripts, and the new functions should be available to you.
* As an optional step, if you're going to be editing the _Microsoft.PowerShell_warppipes.ps1_ file, you'll want to run `git update-index --assume-unchanged Microsoft.PowerShell_warppipes.ps1` to ignore any further changes to the file. This way, you won't accidentally push anything personal up to GitHub! :)

## Provisioning Script
If you're building out a new machine, you can use my provisioning scripts to bootstrap the install process with a lot of the common software I use. It's also a handy starting point if you want to build your own.

To start the process, run the following command in an elevated terminal: `Provision-New-Box`

## License
Do whatever you want! I'm not responsible for anything that blows up.
