# MSFS-FBW-Panel-Randomizer
This Powershell Script randomizes some selected panelstates for the FlyByWire A320Neo and A380 for better realism at cold&dark state.<br/>
Optionally, it can be converted to an .exe for adding it to the startup-configuration of MSFS.<br />

# Usage:
> .\fbw-panelrandomizer.ps1 [-communityfolder "Path-to-Communityfolder"] [-a380x] [-level {1,2}] 


# Compilation for startup .exe:
> Install-Module ps2exe<br />
> win-ps2exe


# Installation
Add in C:\Path\to\MSFS\Localcachefolder\exe.xml:
>  <Launch.Addon>  
>    \<Name\>A32NX-Panelrandomizer\</Name\>  
>    \<Disabled\>False\</Disabled\>  
>    \<Path\>C:\Path\to\fbw-panelrandomizer.exe\</Path\>  
>    \<CommandLine\>C:\MSFS-Communityfolder\flybywire-aircraft-a320-neo\SimObjects\AirPlanes\FlyByWire_A320_NEO\apron.FLT\</CommandLine\>  
>  </Launch.Addon>
