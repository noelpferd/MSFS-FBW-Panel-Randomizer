# MSFS-FBW-Panel-Randomizer
This Powershell Script randomizes some selected panelstates for the FlyByWire A320Neo and A380 (stable & dev) for better realism at cold&dark state.<br />
It's implemented by modifying the appropriate variables in apron.flt.<br/>
Optionally, it can be converted to an .exe for adding it to the autostart configuration of MSFS.<br />

# Usage:
> .\fbw-panelrandomizer.ps1 [-communityfolder "Path-to-Communityfolder"] [-a380] [-advanced] <br /><br />
> Arguments:<br />
> -communityfolder: Set path to custom communityfolder in case of autodetect fails<br />
> -a380: Set panelstates for the FlyByWire A380 instead of A320Neo<br />
> -advanced: airbus was left behind like a mess (non-realistic panelstates, complete pre-startup check has to be done)

# Compilation for startup exe.xml:
> PS > Install-Module ps2exe<br />
> PS > win-ps2exe

![ps2exe](https://github.com/user-attachments/assets/56d6719b-96d8-4034-9719-9ba82f7d2e46)


# Installation
Add in C:\Path\to\MSFS\Localcachefolder\exe.xml:
>  <Launch.Addon>  
>    \<Name\>FBW Panelrandomizer\</Name\>  
>    \<Disabled\>False\</Disabled\>  
>    \<Path\>C:\Path\to\fbw-panelrandomizer.exe\</Path\>  
>  </Launch.Addon><br />

customize the configuration by adding CommandLine:<br />
> <CommandLine\>-communityfolder "C:\MSFS-Communityfolder\" -a380 -advanced</CommandLine\>

# Restore to defaults
This script doesn't do any backup of the original apron.flt. In case of revert, just copy the files from their github page:<br />
A320: https://github.com/flybywiresim/aircraft/blob/master/fbw-a32nx/src/base/flybywire-aircraft-a320-neo/SimObjects/AirPlanes/FlyByWire_A320_NEO/apron.FLT<br />
A380: https://github.com/flybywiresim/aircraft/blob/master/fbw-a380x/src/base/flybywire-aircraft-a380-842/SimObjects/AirPlanes/FlyByWire_A380_842/apron.FLT<br />
or do an update via the flybywire installer
