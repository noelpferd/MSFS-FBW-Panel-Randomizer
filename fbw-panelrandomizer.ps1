<#
.SYNOPSIS
    This Powershell Script randomizes some selected panelstates for the FlyByWire A320Neo and A380 for better realism at cold&dark state.
.PARAMETER communityfolder
    Set path to your MSFS Communityfolder in case of autodetect fails
.PARAMETER a380
    Set panelstates for the FlyByWire A380 instead of A320 Neo
.PARAMETER advanced
    airbus was left behind like a mess (non-realistic panelstates, complete pre-startup check has to be done)
.EXAMPLE
    .\fbw-panelrandomizer.ps1
    Sets realistic panelstates for the FlyByWire A320 Neo while autodetecting your msfs communityfolder
.EXAMPLE
    .\fbw-panelrandomizer.ps1 -communityfolder C:\My\MSFS\Installation\Community -a380
    Sets realistic panelstates for the FlyByWire A380 by defining your custom path to the msfs communityfolder
.EXAMPLE
    .\fbw-panelrandomizer.ps1 -advanced
    Sets messi panelstates for the FlyByWire A320 Neo while autodetecting your msfs communityfolder
#>

param (
    [string] $communityfolder="", [switch] $a380, [switch] $advanced
)

#detect communityfolder
$COMM_FOLDER = ""
$COMM_FOLDERS = @("C:\Users\$env:username\AppData\Local\Packages\Microsoft.FlightSimulator_8wekyb3d8bbwe\LocalCache\Packages\Community", "C:\Users\$env:username\AppData\Roaming\Microsoft Flight Simulator\Packages\Community", "C:\Users\$env:username\AppData\Local\MSFSPackages\Community")
if ($communityfolder -ne "") {
	$COMM_FOLDERS = @($communityfolder) + $COMM_FOLDERS
}

for ($i = 0; $i -lt $COMM_FOLDERS.Length; $i++)
{
	if ((Test-Path $COMM_FOLDERS[$i])) {
		$COMM_FOLDER = $COMM_FOLDERS[$i]
		break
	} 
}

if ($COMM_FOLDER -eq "") {
	Write-Host "Communityfolder not found. Please define the correct path via -communityfolder. Exiting..."
	pause
	Exit
}


if ($a380) {
	$apronflt = $COMM_FOLDER + "\flybywire-aircraft-a380-842\SimObjects\AirPlanes\FlyByWire_A380_842\apron.FLT"
	$manifest = $COMM_FOLDER + "\flybywire-aircraft-a380-842\manifest.json"
} else {
	$apronflt = $COMM_FOLDER + "\flybywire-aircraft-a320-neo\SimObjects\AirPlanes\FlyByWire_A320_NEO\apron.FLT"
	$manifest = $COMM_FOLDER + "\flybywire-aircraft-a320-neo\manifest.json"
}

if (!(Test-Path $apronflt) -Or !(Test-Path $manifest))
{
	Write-Host "FlyByWire Installation not found. Exiting..."
	pause
	Exit
}

# fuzzy detect version (stable/development)
[bool] $stable = 0
(Get-Content $manifest) | Foreach-Object {
	if ($_ -like '*Stable*' ) {
		$stable = 1
	}
}

# get all relevant variables from https://docs.flybywiresim.com/aircraft/a32nx/a32nx-api/a32nx-flightdeck-api/ | grep "Custom LVAR" | grep "R/W"
$items_a320_stable = @(
'A32NX_OVHD_ADIRS_IR_1_MODE_SELECTOR_KNOB',
'A32NX_OVHD_ADIRS_IR_2_MODE_SELECTOR_KNOB',
'A32NX_OVHD_ADIRS_IR_3_MODE_SELECTOR_KNOB',
'A32NX_RMP_L_VHF2_STANDBY_FREQUENCY',
'A32NX_RMP_L_VHF3_STANDBY_FREQUENCY',
'A32NX_RMP_R_VHF1_STANDBY_FREQUENCY',
'A32NX_RMP_R_VHF3_STANDBY_FREQUENCY',
'A32NX_OVHD_COND_CKPT_SELECTOR_KNOB',
'A32NX_OVHD_COND_FWD_SELECTOR_KNOB',
'A32NX_OVHD_COND_AFT_SELECTOR_KNOB',
'A32NX_OVHD_COND_PACK_1_PB_IS_ON',
'A32NX_OVHD_COND_PACK_2_PB_IS_ON',
'XMLVAR_A320_WEATHERRADAR_MODE',
'A32NX_SWITCH_TCAS_TRAFFIC_POSITION',
'A32NX_SWITCH_TCAS_POSITION',
'LANDING_2_RETRACTED',
'LANDING_3_RETRACTED',
'XMLVAR_SWITCH_OVHD_INTLT_NOSMOKING_POSITION',
'XMLVAR_SWITCH_OVHD_INTLT_EMEREXIT_POSITION',
'PUSH_OVHD_OXYGEN_CREW',
'A32NX_KNOB_OVHD_AIRCOND_PACKFLOW_POSITION',
'A32NX_KNOB_OVHD_AIRCOND_XBLEED_POSITION',
'A32NX_EFIS_L_ND_MODE',
'A32NX_EFIS_R_ND_MODE',
'A32NX_EFIS_L_ND_RANGE',
'A32NX_EFIS_R_ND_RANGE',
'A32NX_EFIS_L_NAVAID_1_MODE',
'A32NX_EFIS_L_NAVAID_2_MODE',
'A32NX_EFIS_R_NAVAID_1_MODE',
'A32NX_EFIS_R_NAVAID_2_MODE',
'A32NX_FCU_ALT_INCREMENT_1000',
'A32NX_EFIS_TERR_L_ACTIVE',
'A32NX_EFIS_TERR_R_ACTIVE',
'A32NX_ECAM_SD_CURRENT_PAGE_INDEX',
'A32NX_RMP_L_TOGGLE_SWITCH',
'A32NX_RMP_R_TOGGLE_SWITCH',
'A32NX_PARK_BRAKE_LEVER_POS',
'A32NX_SWITCH_ATC_ALT',
'A32NX_OVHD_ELEC_COMMERCIAL_PB_IS_AUTO',
'A32NX_OVHD_ELEC_GALY_AND_CAB_PB_IS_AUTO',
'A32NX_OVHD_ELEC_AC_ESS_FEED_PB_IS_NORMAL',
'A32NX_OVHD_ELEC_BUS_TIE_PB_IS_AUTO',
'A32NX_OVHD_INTLT_ANN','PUSH_DOORPANEL_VIDEO',
'A32NX_OVHD_ADIRS_IR_1_PB_IS_ON',
'A32NX_OVHD_ADIRS_IR_2_PB_IS_ON',
'A32NX_OVHD_ADIRS_IR_3_PB_IS_ON',
'A32NX_OVHD_ADIRS_ADR_1_PB_IS_ON',
'A32NX_OVHD_ADIRS_ADR_2_PB_IS_ON',
'A32NX_OVHD_ADIRS_ADR_3_PB_IS_ON',
'A32NX_FIRE_GUARD_APU',
'A32NX_FIRE_GUARD_ENG1',
'A32NX_FIRE_GUARD_ENG2',
'A32NX_OVHD_COND_HOT_AIR_PB_IS_ON',
'A32NX_ELAC_1_PUSHBUTTON_PRESSED',
'A32NX_ELAC_2_PUSHBUTTON_PRESSED',
'A32NX_SEC_1_PUSHBUTTON_PRESSED',
'A32NX_SEC_2_PUSHBUTTON_PRESSED',
'A32NX_SEC_3_PUSHBUTTON_PRESSED',
'A32NX_FAC_1_PUSHBUTTON_PRESSED',
'A32NX_FAC_2_PUSHBUTTON_PRESSED',
'A32NX_BRAKE_FAN_BTN_PRESSED',
'A32NX_ATT_HDG_SWITCHING_KNOB',
'A32NX_AIR_DATA_SWITCHING_KNOB',
'A32NX_EIS_DMC_SWITCHING_KNOB',
'A32NX_ECAM_ND_XFR_SWITCHING_KNOB',
'A32NX_RMP_L_SELECTED_MODE',
'A32NX_RMP_R_SELECTED_MODE',
'XMLVAR_A320_WEATHERRADAR_SYS',
'A32NX_SWITCH_RADAR_PWS_POSITION',
'A32NX_TRANSPONDER_MODE',
'A32NX_TRANSPONDER_SYSTEM')

# copy items for a320_dev and do changes
$items_a320_dev = @()
$items_a320_dev = $items_a320_dev + $items_a320_stable
for ($i=0; $i -lt $items_a320_dev.Length; $i++) {
    	if ($items_a320_dev[$i] -eq "A32NX_EFIS_L_ND_MODE") {
		$items_a320_dev[$i] = "A32NX_FCU_EFIS_L_EFIS_MODE"
	}
	if ($items_a320_dev[$i] -eq "A32NX_EFIS_R_ND_MODE") {
		$items_a320_dev[$i] = "A32NX_FCU_EFIS_R_EFIS_MODE"
	}
	if ($items_a320_dev[$i] -eq "A32NX_EFIS_L_ND_RANGE") {
		$items_a320_dev[$i] = "A32NX_FCU_EFIS_L_EFIS_RANGE"
	}
	if ($items_a320_dev[$i] -eq "A32NX_EFIS_R_ND_RANGE") {
		$items_a320_dev[$i] = "A32NX_FCU_EFIS_R_EFIS_RANGE"
	}
	if ($items_a320_dev[$i] -eq "A32NX_EFIS_L_NAVAID_1_MODE") {
		$items_a320_dev[$i] = "A32NX_FCU_EFIS_L_NAVAID_1_MODE"
	}
	if ($items_a320_dev[$i] -eq "A32NX_EFIS_L_NAVAID_2_MODE") {
		$items_a320_dev[$i] = "A32NX_FCU_EFIS_L_NAVAID_2_MODE"
	}
	if ($items_a320_dev[$i] -eq "A32NX_EFIS_R_NAVAID_1_MODE") {
		$items_a320_dev[$i] = "A32NX_FCU_EFIS_R_NAVAID_1_MODE"
	}
	if ($items_a320_dev[$i] -eq "A32NX_EFIS_R_NAVAID_2_MODE") {
		$items_a320_dev[$i] = "A32NX_FCU_EFIS_R_NAVAID_2_MODE"
	}
}

# get all relevant variables from https://docs.flybywiresim.com/aircraft/a380x/a380x-api/a380x-flight-deck-api/ | grep "Custom LVAR" | grep "R/W"
$items_a380_stable = @(
'A32NX_OVHD_ADIRS_IR_1_MODE_SELECTOR_KNOB',
'A32NX_OVHD_ADIRS_IR_2_MODE_SELECTOR_KNOB',
'A32NX_OVHD_ADIRS_IR_3_MODE_SELECTOR_KNOB',
'A32NX_OVHD_COND_CKPT_SELECTOR_KNOB',
'A32NX_OVHD_COND_CABIN_SELECTOR_KNOB',
'A32NX_OVHD_COND_PACK_1_PB_IS_ON',
'A32NX_OVHD_COND_PACK_2_PB_IS_ON',
'A32NX_OVHD_COND_HOT_AIR_1_PB_IS_ON',
'A32NX_OVHD_COND_HOT_AIR_2_PB_IS_ON',
'XMLVAR_A320_WEATHERRADAR_MODE',
'A32NX_SWITCH_TCAS_TRAFFIC_POSITION',
'LANDING_2_RETRACTED',
'LANDING_3_RETRACTED',
'XMLVAR_SWITCH_OVHD_INTLT_NOSMOKING_POSITION',
'XMLVAR_SWITCH_OVHD_INTLT_EMEREXIT_POSITION',
'PUSH_OVHD_OXYGEN_CREW',
'A32NX_KNOB_OVHD_AIRCOND_PACKFLOW_POSITION',
'A32NX_KNOB_OVHD_AIRCOND_XBLEED_POSITION',
'A32NX_EFIS_L_ND_MODE',
'A32NX_EFIS_R_ND_MODE',
'A32NX_EFIS_L_ND_RANGE',
'A32NX_EFIS_R_ND_RANGE',
'A32NX_EFIS_L_NAVAID_1_MODE',
'A32NX_EFIS_R_NAVAID_1_MODE',
'A32NX_EFIS_L_NAVAID_2_MODE',
'A32NX_EFIS_R_NAVAID_2_MODE',
'A32NX_EFIS_TERR_L_ACTIVE',
'A32NX_EFIS_TERR_R_ACTIVE',
'A32NX_ECAM_SD_CURRENT_PAGE_INDEX',
'A32NX_RMP_L_TOGGLE_SWITCH',
'A32NX_RMP_R_TOGGLE_SWITCH',
'A32NX_PARK_BRAKE_LEVER_POS',
'A32NX_SWITCH_ATC_ALT',
'A32NX_OVHD_ELEC_COMMERCIAL_PB_IS_AUTO',
'A32NX_OVHD_ELEC_GALY_AND_CAB_PB_IS_AUTO',
'A32NX_OVHD_ELEC_AC_ESS_FEED_PB_IS_NORMAL',
'A32NX_OVHD_ELEC_BUS_TIE_PB_IS_AUTO',
'A32NX_OVHD_INTLT_ANN','PUSH_DOORPANEL_VIDEO',
'A32NX_OVHD_ADIRS_IR_1_PB_IS_ON',
'A32NX_OVHD_ADIRS_IR_2_PB_IS_ON',
'A32NX_OVHD_ADIRS_IR_3_PB_IS_ON',
'A32NX_OVHD_ADIRS_ADR_1_PB_IS_ON',
'A32NX_OVHD_ADIRS_ADR_2_PB_IS_ON',
'A32NX_OVHD_ADIRS_ADR_3_PB_IS_ON',
'A32NX_FIRE_GUARD_APU',
'A32NX_FIRE_GUARD_ENG1',
'A32NX_FIRE_GUARD_ENG2',
'A32NX_ELAC_1_PUSHBUTTON_PRESSED',
'A32NX_ELAC_2_PUSHBUTTON_PRESSED',
'A32NX_SEC_1_PUSHBUTTON_PRESSED',
'A32NX_SEC_2_PUSHBUTTON_PRESSED',
'A32NX_SEC_3_PUSHBUTTON_PRESSED',
'A32NX_FAC_1_PUSHBUTTON_PRESSED',
'A32NX_FAC_2_PUSHBUTTON_PRESSED',
'A32NX_BRAKE_FAN_BTN_PRESSED',
'A32NX_ATT_HDG_SWITCHING_KNOB',
'A32NX_AIR_DATA_SWITCHING_KNOB',
'A32NX_EIS_DMC_SWITCHING_KNOB',
'A32NX_ECAM_ND_XFR_SWITCHING_KNOB',
'A32NX_RMP_L_SELECTED_MODE'
,'A32NX_RMP_R_SELECTED_MODE',
'XMLVAR_A320_WEATHERRADAR_SYS',
'A32NX_SWITCH_RADAR_PWS_POSITION',
'A32NX_TRANSPONDER_MODE',
'A32NX_TRANSPONDER_SYSTEM',
'XMLVAR_Baro1_Mode',
'XMLVAR_Baro_Selector_HPA_1')

# copy items for a380_dev and do changes
$items_a380_dev = @()
$items_a380_dev = $items_a380_dev + $items_a380_stable
# currently no significant changes in a380


# which items to be used?
if ($a380) {
	if ($stable){
		$items = $items_a380_stable
	} else {
		$items = $items_a380_dev
	}
} else {
	if ($stable){
		$items = $items_a320_stable
	} else {
		$items = $items_a320_dev
	}
}

# initially add missing variables to file
$addvars = ""
for ($i = 0; $i -lt $items.Length; $i++)
{	
	$sel = Select-String -Path $apronflt -Pattern $items[$i]
	if ($sel -eq $null)
	{
		$addvars = $addvars +"`n"+$items[$i] + "=0"
		
	}
}

# define some random values for frequency
$COMM_L_VHF2_STBY = (Get-Random -Minimum 118 -Maximum 137).toString()+(Get-Random "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")+(Get-Random "00", "05", "10", "15", "25", "30", "35", "40", "50", "55", "60", "65", "75", "80", "85", "90")+"000"
$COMM_L_VHF3_STBY = (Get-Random -Minimum 118 -Maximum 137).toString()+(Get-Random "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")+(Get-Random "00", "05", "10", "15", "25", "30", "35", "40", "50", "55", "60", "65", "75", "80", "85", "90")+"000"
$COMM_R_VHF1_STBY = (Get-Random -Minimum 118 -Maximum 137).toString()+(Get-Random "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")+(Get-Random "00", "05", "10", "15", "25", "30", "35", "40", "50", "55", "60", "65", "75", "80", "85", "90")+"000"
$COMM_R_VHF3_STBY = (Get-Random -Minimum 118 -Maximum 137).toString()+(Get-Random "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")+(Get-Random "00", "05", "10", "15", "25", "30", "35", "40", "50", "55", "60", "65", "75", "80", "85", "90")+"000"

(Get-Content $apronflt) | Foreach-Object {
    $_ -replace '\[LocalVars\.0\]', "[LocalVars.0]$addvars" `
	-replace 'A32NX_RMP_L_VHF2_STANDBY_FREQUENCY\s*=\s*\d+', "A32NX_RMP_L_VHF2_STANDBY_FREQUENCY=$COMM_L_VHF2_STBY" `
	-replace 'A32NX_RMP_L_VHF3_STANDBY_FREQUENCY\s*=\s*\d+', "A32NX_RMP_L_VHF3_STANDBY_FREQUENCY=$COMM_L_VHF3_STBY" `
	-replace 'A32NX_RMP_R_VHF1_STANDBY_FREQUENCY\s*=\s*\d+', "A32NX_RMP_R_VHF1_STANDBY_FREQUENCY=$COMM_R_VHF1_STBY" `
	-replace 'A32NX_RMP_R_VHF3_STANDBY_FREQUENCY\s*=\s*\d+', "A32NX_RMP_R_VHF3_STANDBY_FREQUENCY=$COMM_R_VHF3_STBY" `
	-replace 'A32NX_OVHD_COND_CKPT_SELECTOR_KNOB\s*=\s*\d+', "A32NX_OVHD_COND_CKPT_SELECTOR_KNOB=$(Get-Random -Minimum 50 -Maximum 251)" `
	-replace 'A32NX_OVHD_COND_FWD_SELECTOR_KNOB\s*=\s*\d+', "A32NX_OVHD_COND_FWD_SELECTOR_KNOB=$(Get-Random -Minimum 50 -Maximum 251)" `
	-replace 'A32NX_OVHD_COND_AFT_SELECTOR_KNOB\s*=\s*\d+', "A32NX_OVHD_COND_AFT_SELECTOR_KNOB=$(Get-Random -Minimum 50 -Maximum 251)" `
	-replace 'XMLVAR_A320_WEATHERRADAR_MODE\s*=\s*\d', "XMLVAR_A320_WEATHERRADAR_MODE = $(Get-Random -Maximum 4)" `
	-replace 'A32NX_SWITCH_TCAS_TRAFFIC_POSITION\s*=\s*\d', "A32NX_SWITCH_TCAS_TRAFFIC_POSITION = $(Get-Random -Maximum 3)" `
	-replace 'XMLVAR_SWITCH_OVHD_INTLT_NOSMOKING_POSITION\s*=\s*\d', "XMLVAR_SWITCH_OVHD_INTLT_NOSMOKING_POSITION=$(Get-Random -Minimum 1 -Maximum 3)" `
	-replace 'PUSH_OVHD_OXYGEN_CREW\s*=\s*\d', "PUSH_OVHD_OXYGEN_CREW=$(Get-Random -Maximum 2)" `
	-replace 'A32NX_FCU_EFIS_L_EFIS_MODE\s*=\s*\d', "A32NX_FCU_EFIS_L_EFIS_MODE=$(Get-Random -Maximum 5)" `
	-replace 'A32NX_EFIS_L_ND_MODE\s*=\s*\d', "A32NX_EFIS_L_ND_MODE=$(Get-Random -Maximum 5)" `
	-replace 'A32NX_FCU_EFIS_R_EFIS_MODE\s*=\s*\d', "A32NX_FCU_EFIS_R_EFIS_MODE=$(Get-Random -Maximum 5)" `
	-replace 'A32NX_EFIS_R_ND_MODE\s*=\s*\d', "A32NX_EFIS_R_ND_MODE=$(Get-Random -Maximum 5)" `
	-replace 'A32NX_FCU_EFIS_L_EFIS_RANGE\s*=\s*\d', "A32NX_FCU_EFIS_L_EFIS_RANGE=$(Get-Random -Maximum 6)" `
	-replace 'A32NX_EFIS_L_ND_RANGE\s*=\s*\d', "A32NX_EFIS_L_ND_RANGE=$(Get-Random -Maximum 6)" `
	-replace 'A32NX_FCU_EFIS_R_EFIS_RANGE\s*=\s*\d', "A32NX_FCU_EFIS_R_EFIS_RANGE=$(Get-Random -Maximum 6)" `
	-replace 'A32NX_EFIS_R_ND_RANGE\s*=\s*\d', "A32NX_EFIS_R_ND_RANGE=$(Get-Random -Maximum 6)" `
	-replace 'A32NX_FCU_EFIS_L_NAVAID_1_MODE\s*=\s*\d', "A32NX_FCU_EFIS_L_NAVAID_1_MODE=$(Get-Random -Maximum 3)" `
	-replace 'A32NX_EFIS_L_NAVAID_1_MODE\s*=\s*\d', "A32NX_EFIS_L_NAVAID_1_MODE=$(Get-Random -Maximum 3)" `
	-replace 'A32NX_FCU_EFIS_R_NAVAID_1_MODE\s*=\s*\d', "A32NX_FCU_EFIS_R_NAVAID_1_MODE=$(Get-Random -Maximum 3)" `
	-replace 'A32NX_EFIS_R_NAVAID_1_MODE\s*=\s*\d', "A32NX_EFIS_R_NAVAID_1_MODE=$(Get-Random -Maximum 3)" `
	-replace 'A32NX_FCU_EFIS_L_NAVAID_2_MODE\s*=\s*\d', "A32NX_FCU_EFIS_L_NAVAID_2_MODE=$(Get-Random -Maximum 3)" `
	-replace 'A32NX_EFIS_L_NAVAID_2_MODE\s*=\s*\d', "A32NX_EFIS_L_NAVAID_2_MODE=$(Get-Random -Maximum 3)" `
	-replace 'A32NX_FCU_EFIS_R_NAVAID_2_MODE\s*=\s*\d', "A32NX_FCU_EFIS_R_NAVAID_2_MODE=$(Get-Random -Maximum 3)" `
	-replace 'A32NX_EFIS_R_NAVAID_2_MODE\s*=\s*\d', "A32NX_EFIS_R_NAVAID_2_MODE=$(Get-Random -Maximum 3)" `
	-replace 'A32NX_FCU_ALT_INCREMENT_1000\s*=\s*\d', "A32NX_FCU_ALT_INCREMENT_1000=$(Get-Random -Maximum 2)" `
	-replace 'A32NX_EFIS_TERR_L_ACTIVE\s*=\s*\d', "A32NX_EFIS_TERR_L_ACTIVE=$(Get-Random -Maximum 2)" `
	-replace 'A32NX_EFIS_TERR_R_ACTIVE\s*=\s*\d', "A32NX_EFIS_TERR_R_ACTIVE=$(Get-Random -Maximum 2)" `
	-replace 'A32NX_ECAM_SD_CURRENT_PAGE_INDEX\s*=\s*-?\d+', "A32NX_ECAM_SD_CURRENT_PAGE_INDEX=$(Get-Random -Minimum -1 -Maximum 12)" `
	-replace 'A32NX_OVHD_INTLT_ANN\s*=\s*\d', "A32NX_OVHD_INTLT_ANN=$(Get-Random -Minimum 1 -Maximum 3)" `
	-replace 'A32NX_OVHD_COND_PACK_1_PB_IS_ON\s*=\s*\d', "A32NX_OVHD_COND_PACK_1_PB_IS_ON=$(Get-Random -Maximum 2)" `
	-replace 'A32NX_OVHD_COND_PACK_2_PB_IS_ON\s*=\s*\d', "A32NX_OVHD_COND_PACK_2_PB_IS_ON=$(Get-Random -Maximum 2)"
} | Set-Content $apronflt -force


if ($advanced) {
	(Get-Content $apronflt) | Foreach-Object {
		$_ 	-replace 'A32NX_OVHD_ADIRS_IR_1_MODE_SELECTOR_KNOB\s*=\s*\d', "A32NX_OVHD_ADIRS_IR_1_MODE_SELECTOR_KNOB=$(Get-Random -Maximum 3)" `
			-replace 'A32NX_OVHD_ADIRS_IR_2_MODE_SELECTOR_KNOB\s*=\s*\d', "A32NX_OVHD_ADIRS_IR_2_MODE_SELECTOR_KNOB=$(Get-Random -Maximum 3)" `
			-replace 'A32NX_OVHD_ADIRS_IR_3_MODE_SELECTOR_KNOB\s*=\s*\d', "A32NX_OVHD_ADIRS_IR_3_MODE_SELECTOR_KNOB=$(Get-Random -Maximum 3)" `
			-replace 'A32NX_OVHD_ADIRS_IR_1_PB_IS_ON\s*=\s*\d', "A32NX_OVHD_ADIRS_IR_1_PB_IS_ON=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_OVHD_ADIRS_IR_2_PB_IS_ON\s*=\s*\d', "A32NX_OVHD_ADIRS_IR_2_PB_IS_ON=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_OVHD_ADIRS_IR_3_PB_IS_ON\s*=\s*\d', "A32NX_OVHD_ADIRS_IR_3_PB_IS_ON=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_OVHD_ADIRS_ADR_1_PB_IS_ON\s*=\s*\d', "A32NX_OVHD_ADIRS_ADR_1_PB_IS_ON=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_OVHD_ADIRS_ADR_2_PB_IS_ON\s*=\s*\d', "A32NX_OVHD_ADIRS_ADR_2_PB_IS_ON=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_OVHD_ADIRS_ADR_3_PB_IS_ON\s*=\s*\d', "A32NX_OVHD_ADIRS_ADR_3_PB_IS_ON=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_PARK_BRAKE_LEVER_POS\s*=\s*\d', "A32NX_PARK_BRAKE_LEVER_POS=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_SWITCH_TCAS_POSITION\s*=\s*\d', "A32NX_SWITCH_TCAS_POSITION = $(Get-Random -Maximum 2)" `
			-replace 'XMLVAR_SWITCH_OVHD_INTLT_EMEREXIT_POSITION\s*=\s*\d', "XMLVAR_SWITCH_OVHD_INTLT_EMEREXIT_POSITION=$(Get-Random -Maximum 3)" `
			-replace 'XMLVAR_SWITCH_OVHD_INTLT_NOSMOKING_POSITION\s*=\s*\d', "XMLVAR_SWITCH_OVHD_INTLT_NOSMOKING_POSITION=$(Get-Random -Maximum 3)" `
			-replace 'LANDING_2_RETRACTED\s*=\s*\d', "LANDING_2_RETRACTED=$(Get-Random -Maximum 2)" `
			-replace 'LANDING_3_RETRACTED\s*=\s*\d', "LANDING_3_RETRACTED=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_KNOB_OVHD_AIRCOND_XBLEED_POSITION\s*=\s*\d', "A32NX_KNOB_OVHD_AIRCOND_XBLEED_POSITION=$(Get-Random -Maximum 3)" `
			-replace 'A32NX_OVHD_ELEC_COMMERCIAL_PB_IS_AUTO\s*=\s*\d', "A32NX_OVHD_ELEC_COMMERCIAL_PB_IS_AUTO=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_OVHD_ELEC_GALY_AND_CAB_PB_IS_AUTO\s*=\s*\d', "A32NX_OVHD_ELEC_GALY_AND_CAB_PB_IS_AUTO=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_OVHD_ELEC_BUS_TIE_PB_IS_AUTO\s*=\s*\d', "A32NX_OVHD_ELEC_BUS_TIE_PB_IS_AUTO=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_OVHD_ELEC_AC_ESS_FEED_PB_IS_NORMAL\s*=\s*\d', "A32NX_OVHD_ELEC_AC_ESS_FEED_PB_IS_NORMAL=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_OVHD_INTLT_ANN\s*=\s*\d', "A32NX_OVHD_INTLT_ANN=$(Get-Random -Maximum 3)" `
			-replace 'PUSH_DOORPANEL_VIDEO\s*=\s*\d', "PUSH_DOORPANEL_VIDEO=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_FIRE_GUARD_APU\s*=\s*\d', "A32NX_FIRE_GUARD_APU=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_FIRE_GUARD_ENG1\s*=\s*\d', "A32NX_FIRE_GUARD_ENG1=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_FIRE_GUARD_ENG2\s*=\s*\d', "A32NX_FIRE_GUARD_ENG2=$(Get-Random -Maximum 2)" `
            		-replace 'A32NX_OVHD_COND_HOT_AIR_PB_IS_ON\s*=\s*\d', "A32NX_OVHD_COND_HOT_AIR_PB_IS_ON=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_ELAC_1_PUSHBUTTON_PRESSED\s*=\s*\d', "A32NX_ELAC_1_PUSHBUTTON_PRESSED=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_ELAC_2_PUSHBUTTON_PRESSED\s*=\s*\d', "A32NX_ELAC_2_PUSHBUTTON_PRESSED=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_SEC_1_PUSHBUTTON_PRESSED\s*=\s*\d', "A32NX_SEC_1_PUSHBUTTON_PRESSED=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_SEC_2_PUSHBUTTON_PRESSED\s*=\s*\d', "A32NX_SEC_2_PUSHBUTTON_PRESSED=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_SEC_3_PUSHBUTTON_PRESSED\s*=\s*\d', "A32NX_SEC_3_PUSHBUTTON_PRESSED=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_FAC_1_PUSHBUTTON_PRESSED\s*=\s*\d', "A32NX_FAC_1_PUSHBUTTON_PRESSED=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_FAC_2_PUSHBUTTON_PRESSED\s*=\s*\d', "A32NX_FAC_2_PUSHBUTTON_PRESSED=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_AUTOBRAKES_ARMED_MODE_SET\s*=\s*\d', "A32NX_AUTOBRAKES_ARMED_MODE_SET=$(Get-Random -Maximum 4)" `
			-replace 'A32NX_ATT_HDG_SWITCHING_KNOB\s*=\s*\d', "A32NX_ATT_HDG_SWITCHING_KNOB=$(Get-Random -Maximum 3)" `
			-replace 'A32NX_AIR_DATA_SWITCHING_KNOB\s*=\s*\d', "A32NX_AIR_DATA_SWITCHING_KNOB=$(Get-Random -Maximum 3)" `
			-replace 'A32NX_EIS_DMC_SWITCHING_KNOB\s*=\s*\d', "A32NX_EIS_DMC_SWITCHING_KNOB=$(Get-Random -Maximum 3)" `
			-replace 'A32NX_ECAM_ND_XFR_SWITCHING_KNOB\s*=\s*\d', "A32NX_ECAM_ND_XFR_SWITCHING_KNOB=$(Get-Random -Maximum 3)" `
			-replace 'A32NX_RMP_L_SELECTED_MODE\s*=\s*\d', "A32NX_RMP_L_SELECTED_MODE=$(Get-Random -Maximum 4)" `
			-replace 'A32NX_RMP_R_SELECTED_MODE\s*=\s*\d', "A32NX_RMP_R_SELECTED_MODE=$(Get-Random -Maximum 4)" `
			-replace 'XMLVAR_A320_WEATHERRADAR_SYS\s*=\s*\d', "XMLVAR_A320_WEATHERRADAR_SYS=$(Get-Random -Maximum 3)" `
			-replace 'A32NX_SWITCH_RADAR_PWS_POSITION\s*=\s*\d', "A32NX_SWITCH_RADAR_PWS_POSITION=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_TRANSPONDER_MODE\s*=\s*\d', "A32NX_TRANSPONDER_MODE=$(Get-Random -Maximum 3)" `
			-replace 'A32NX_TRANSPONDER_SYSTEM\s*=\s*\d', "A32NX_TRANSPONDER_SYSTEM=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_BRAKE_FAN_BTN_PRESSED\s*=\s*\d', "A32NX_BRAKE_FAN_BTN_PRESSED=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_SWITCH_ATC_ALT\s*=\s*\d', "A32NX_SWITCH_ATC_ALT=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_RMP_L_TOGGLE_SWITCH\s*=\s*\d', "A32NX_RMP_L_TOGGLE_SWITCH=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_RMP_R_TOGGLE_SWITCH\s*=\s*\d', "A32NX_RMP_R_TOGGLE_SWITCH=$(Get-Random -Maximum 2)" `
			-replace 'A32NX_KNOB_OVHD_AIRCOND_PACKFLOW_POSITION\s*=\s*\d', "A32NX_KNOB_OVHD_AIRCOND_PACKFLOW_POSITION=$(Get-Random -Maximum 3)"
	} | Set-Content $apronflt -force
} 