# WallpaperChangeOnRotate
Windows 10 Powershell Script for automatically swapping between 2 wallpapers based on screen orientation. Startup cmd script can be placed in Startup folder to automatically run on startup. Tested on Surface Pro 4.

## Auto-start script on login
1. Windows Key + R (Open Run Window)
1. put "shell:startup" in the box
1. put ScriptStartup.cmd into the folder
1. change "Path-to\WallpaperSwap.ps1" in ScriptStartup.cmd to the path for WallpaperSwap.ps1

Be sure to specify the directory of the wallpaper folder directory and wallpaper file names ($WpDir and $dth/$dtv respectively) in WallpaperSwap.ps1
