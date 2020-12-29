# Set-Wallpaper function credit to Jose Espitia https://www.joseespitia.com/2017/09/15/set-wallpaper-powershell-function/

Function Set-WallPaper {
 
<#
 
    .SYNOPSIS
    Applies a specified wallpaper to the current user's desktop
    
    .PARAMETER Image
    Provide the exact path to the image
 
    .PARAMETER Style
    Provide wallpaper style (Example: Fill, Fit, Stretch, Tile, Center, or Span)
  
    .EXAMPLE
    Set-WallPaper -Image "C:\Wallpaper\Default.jpg"
    Set-WallPaper -Image "C:\Wallpaper\Background.jpg" -Style Fit
  
#>
 
param (
    [parameter(Mandatory=$True)]
    # Provide path to image
    [string]$Image,
    # Provide wallpaper style that you would like applied
    [parameter(Mandatory=$False)]
    [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
    [string]$Style
)
 
$WallpaperStyle = Switch ($Style) {
  
    "Fill" {"10"}
    "Fit" {"6"}
    "Stretch" {"2"}
    "Tile" {"0"}
    "Center" {"0"}
    "Span" {"22"}
  
}
 
If($Style -eq "Tile") {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force
 
}
Else {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force
 
}
 
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
  
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
  
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
  
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
  
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

Add-Type -AssemblyName System.Windows.Forms

$WpDir = "WallpaperDirectorPath"

#$scriptPath = $(get-location).Path

#$dth = $scriptPath + "\Wallpapers\dth.jpg"
$dth = $WpDir + "filename.jpg"
#$lsh = $WpDir + "filename.jpg"

#$dtv = $scriptPath + "\Wallpapers\dtv.jpg"
$dtv = $WpDir + "filename.jpg"
#$lsv = $WpDir + "filename"


<#
    Check Screen Orientation and set to variable
    Angle0 +90 each physical tablet rotation clockwise;
    Default = Angle0
    bottom set to right = Angle90
    bottom set to top = Angle180
    bottom set to left = Angle270
#>
$ScreenOrientation = [System.Windows.Forms.SystemInformation]::ScreenOrientation
#regex to grab digits and parse
$ScreenAngle = [int]::Parse(($ScreenOrientation -replace '\D+(\d+)','$1'))
#easier values to work with
if ($ScreenAngle -ge 180){ $ScreenAngle -= 180 }

#"Start Angle: " + $ScreenAngle
Do
{
    #"Do Loop"
    #"Current ScreenAngle: " + $ScreenAngle
    $value = [int]::Parse(([System.Windows.Forms.SystemInformation]::ScreenOrientation -replace '\D+(\d+)','$1'))
    if ($value -ge 180){ $value -= 180 }
    #"value" + $value
    if ($value -ne $ScreenAngle){
        $ScreenAngle = $value
        if($ScreenAngle -eq 0){
            Set-WallPaper -Image $dth -Style Fill
            #"Set wallpaper to dth"
            #Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name LockScreenImage -value $lsh
        }
        elseif($ScreenAngle -eq 90){
            Set-WallPaper -Image $dtv -Style Fill 
            #"Set wallpaper to dtv"
            #Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name LockScreenImage -value $lsv
        }
        else{
        #Do Nothing
        }
    }
    #"Sleep"
    sleep .5    
}    
while ($true)