# Ce script s execute avec powershell 7
# pour verifier quelle version vous utiliser executer:
# 
#       $PSVersionTable



############ FUNCTION
# Art
Function Get-WindowsArt()
{
    [string[]] $ArtArray  =
            "                         ....::::       ",
            "                 ....::::::::::::       ",
            "        ....:::: ::::::::::::::::       ",
            "....:::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            "................ ................       ",
            ":::::::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            "'''':::::::::::: ::::::::::::::::       ",
            "        '''':::: ::::::::::::::::       ",
            "                 ''''::::::::::::       ",
            "                         ''''::::       ",
            "                                        ",
            "                                        ",
            "                                        ";
    
    return $ArtArray;
}

# Variable 0
function Get-SoftHKCU {
    $InstalledSoftware1 = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
    foreach($obj in $InstalledSoftware1){
        [pscustomobject] @{
        DisplayName = $obj.GetValue('DisplayName')
        DisplayVersion = $obj.GetValue('DisplayVersion')
    }
}}
function Get-SoftHKLM{
    $InstalledSoftware2 = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
    foreach($obj in $InstalledSoftware2){
        [pscustomobject] @{
            DisplayName= $obj.GetValue('DisplayName')  
            DisplayVersion= $obj.GetValue('DisplayVersion')
        }  
}}

#############
$backupPath = "$env:userprofile\desktop\InfoSys\TachesWindows"

$taskFolders = (Get-ScheduledTask).TaskPath | Where-Object { ($_ -notmatch "Microsoft") } | Select-Object -Unique

Write-Host "Debut de l exportation des taches." -ForegroundColor Cyan

if (Test-Path -Path $backupPath) {
    Write-Host "le Fichier existe deja: $backupPath" -ForegroundColor Yellow
}
else {
    New-Item -ItemType Directory -Path $backupPath | Out-Null
    Write-Host "Chemin Creer: $backupPath" -ForegroundColor Green
}

foreach ($taskFolder in $taskFolders) {
    Write-Host "Dossier InfoSys\TachesWindows: $taskFolder" -ForegroundColor Cyan

    if ($taskFolder -ne "\") {
        $folderPath = "$backupPath$taskFolder"

        if (-not (Test-Path -Path $folderPath)) {
            New-Item -ItemType Directory -Path $folderPath | Out-Null
        }
        else {
            Write-Host "Le fichier existe deja: $folderPath" -ForegroundColor Yellow
        }
    }

    $tasks = Get-ScheduledTask -TaskPath $taskFolder -ErrorAction SilentlyContinue

    foreach ($task in $tasks) {
        $taskName = $task.TaskName

        # Export the task and save it to a file
        $taskInfo = Export-ScheduledTask -TaskName $taskName -TaskPath $taskFolder
        $taskInfo | Out-File "$backupPath$taskFolder$taskName.xml"
        Write-Host "Saved file $backupPath$taskFolder$taskName.xml" -ForegroundColor Cyan
    }
}


#Prompts for Computer Name
powershell mode "300" ; &{ Param (
    [parameter(Mandatory = $false)]$Computer
)
#Variables
$SystemEnclosure = Get-CimInstance win32_systemenclosure -ComputerName $computer
$OS = Get-CimInstance Win32_OperatingSystem -ComputerName $Computer
#Creating Hash table from variables
$PCInfo = @{
    Manufacturer   = $SystemEnclosure.Manufacturer
    PCName         = $OS.CSName
    OS             = $OS.Caption
    Architecture   = $OS.OSArchitecture
    AssetTag       = $systemenclosure.serialnumber
    OSVersion      = $OS.Version
    InstallDate    = $OS.InstallDate
    LastBootUpTime = $OS.LastBootUpTime
}
#Writing to Host
Write-Host " "
Write-Host "Information sur la configuration" -ForegroundColor Yellow
Write-Host "Computer Info" -ForegroundColor Cyan
Write-Output "Computer Info"
Get-WindowsArt

#Display Hash Table
$PCInfo.getenumerator() | Sort-Object -Property name | Format-Table -AutoSize
Start-Sleep -Seconds 2
#Writing to Host
Write-Host "Computer Bios Info" -ForegroundColor Cyan
Write-Output "Computer Bios Info"

Get-WmiObject -Class Win32_BIOS | Select-Object SMBIOSBIOSVersion,Manufacturer,Name,SerialNumber,Version
Start-Sleep -Seconds 2
#Writing to Host
Write-Host "Computer GPU Info" -ForegroundColor Cyan
Write-Output "Computer GPU Info"

Get-CimInstance -ClassName Win32_VideoController | Select-Object Caption ,PNPDeviceID, DriverDate, DriverVersion, VideoModeDescription

#Writing to Host
Write-Host "Computer MONITOR Info" -ForegroundColor Cyan
Write-Output "Computer MONITOR Info"
Get-WmiObject win32_desktopmonitor;
Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams;
Get-WmiObject win32_videocontroller | Select-Object caption, CurrentHorizontalResolution, CurrentVerticalResolution, MaxRefreshRate, MinRefreshRate, currentrefreshrate
Start-Sleep -Seconds 2;
#Writing to Host


Get-ciminstance wmimonitorID -namespace root\wmi |
ForEach-Object {
    $adapterTypes = @{ #https://www.magnumdb.com/search?q=parent:D3DKMDT_VIDEO_OUTPUT_TECHNOLOGY
        '-2'         = 'Unknown'
        '-1'         = 'Unknown'
        '0'          = 'VGA'
        '1'          = 'S-Video'
        '2'          = 'Composite'
        '3'          = 'Component'
        '4'          = 'DVI'
        '5'          = 'HDMI'
        '6'          = 'LVDS'
        '8'          = 'D-Jpn'
        '9'          = 'SDI'
        '10'         = 'DisplayPort (external)'
        '11'         = 'DisplayPort (internal)'
        '12'         = 'Unified Display Interface'
        '13'         = 'Unified Display Interface (embedded)'
        '14'         = 'SDTV dongle'
        '15'         = 'Miracast'
        '16'         = 'Internal'
        '2147483648' = 'Internal'
    }
    $Instance = $_.InstanceName
    $Sizes = Get-CimInstance -Namespace root\wmi -Class WmiMonitorBasicDisplayParams | where-object { $_.instanceName -like $Instance }
    $connections = (Get-CimInstance WmiMonitorConnectionParams -Namespace root/wmi | where-object { $_.instanceName -like $Instance }).VideoOutputTechnology
    [pscustomobject]@{
        Manufacturer   = [System.Text.Encoding]::ASCII.GetString($_.ManufacturerName).Trim(0x00)
        Name           = [System.Text.Encoding]::ASCII.GetString($_.UserFriendlyName).Trim(0x00)
        Serial         = [System.Text.Encoding]::ASCII.GetString($_.SerialNumberID).Trim(0x00)
        Size           = ([System.Math]::Round(([System.Math]::Sqrt([System.Math]::Pow($Sizes.MaxHorizontalImageSize, 2) + [System.Math]::Pow($_.MaxVerticalImageSize, 2)) / 2.54), 0))
        ConnectionType = $adapterTypes."$connections"
    }
}
Start-Sleep -Seconds 2
#Writing to Host
Write-Host "Computer Display Info" -ForegroundColor Cyan
Write-Output "Computer Display Info"

wmic desktopmonitor get Caption,MonitorType,MonitorManufacturer,Name
Start-Sleep -Seconds 2
#Writing to Host

Write-Host "Computer Disk Info" -ForegroundColor Cyan
Write-Output "Computer Disk Info"
#Display Drives
wmic diskdrive get caption,SerialNumber,status
Get-PhysicalDisk |Format-Table -Wrap ; 
Get-disk |Format-Table -Wrap ; 
Get-Partition ; 
Get-Volume |Format-Table -Wrap ;
Get-CimInstance win32_logicaldisk -Filter "drivetype=3" -computer $computer |
Format-Table -Property DeviceID, Volumename, `
@{Name = "SizeGB"; Expression = { [math]::Round($_.Size / 1GB) } }, `
@{Name = "FreeGB"; Expression = { [math]::Round($_.Freespace / 1GB, 2) } }, `
@{Name = "PercentFree"; Expression = { [math]::Round(($_.Freespace / $_.size) * 100, 2) } };
#Memory
Get-CimInstance win32_physicalmemory | Select-Object Manufacturer,PartNumber, Banklabel, Configuredclockspeed,Devicelocator, @{Name = 'Capacity';Expression = {"$($_.Capacity / 1gb)" + 'GB'}},Serialnumber | Format-Table -AutoSize 
} | Out-File $env:USERPROFILE\Desktop\InfoSys\InfoSysGenerale.txt
Start-Sleep -Seconds 2
$Network ="$env:USERPROFILE\Desktop\InfoSys\Network"
New-Item -ItemType Directory -Path $Network
&{netsh interface tcp show global ;Get-CimInstance win32_networkadapterconfiguration -computer $computer | Where-Object { $null -ne $_.IPAddress } | Select-Object IPAddress, DefaultIPGateway, DNSServerSearchOrder, IPSubnet, MACAddress, Caption, DHCPEnabled, DHCPServer, DNSDomainSuffixSearchOrder | Format-List }| Out-File $Network\NetworkInfo.txt ;
netsh wlan show wlanreport

Start-Sleep -Seconds 2
#Startup application
Get-CimInstance Win32_StartupCommand |Select-Object Name, command, Location, User | Format-Table | Out-File $env:USERPROFILE\Desktop\InfoSys\StartupApplication.txt ;
# List Installed Software Registry
$Software = "$env:userprofile\desktop\InfoSys\Software"

New-Item -ItemType Directory -Path  $Software
Get-SoftHKLM | Out-File $env:USERPROFILE\Desktop\InfoSys\Software\InstalledSoftwareHKLM.txt ;

Write-Host "Software Installed Registry HKLM" -ForegroundColor Cyan
Write-Output "Software Installed Registry HKLM"

Get-SoftHKCU | Out-File $env:USERPROFILE\Desktop\InfoSys\Software\InstalledSoftwareHKCU.txt ;

Write-Host "Software Installed Registry HKCU" -ForegroundColor Cyan
Write-Output "Software Installed Registry HKCU"
# List services
$Services = "$env:userprofile\desktop\InfoSys\Services"
New-Item -ItemType Directory -Path  $Services
Get-Service | sort-Object name | Format-Table name,status,Description | Out-File $env:USERPROFILE\Desktop\InfoSys\Services\Services.txt ;
Write-Host "Liste des services" -ForegroundColor Cyan
Write-Output "Services Windows"
# Defender
$Defender = "$env:userprofile\desktop\InfoSys\Defender"
New-Item -ItemType Directory -Path $Defender
get-mpThreatDetection | Sort-Object RemediationTime -Descending | Select-Object RemediationTime,ProcessName,Resources | Format-List | Out-File $env:USERPROFILE\Desktop\InfoSys\Defender\Detection.txt ;
Get-MpThreat | Sort-Object DidThreatExecute -Descending | Select-Object ThreatName,SeverityID,DidThreatExecute,IsActive | Out-File $env:USERPROFILE\Desktop\InfoSys\Defender\StatusDetection.txt ;
Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct | Out-File $env:USERPROFILE\Desktop\InfoSys\Defender\StatusAntiVirus.txt ;
# Windows Update Logs
$Wlogs = "$env:USERPROFILE\Desktop\InfoSys\Wlogs"
New-Item -ItemType Directory -Path $Wlogs
Get-WindowsUpdateLog | Format-List ;
Get-WmiObject -Class win32_reliabilityRecords -Filter "SourceName='Microsoft-Windows-WindowsUpdateClient'" | Where-Object { $_.message -match "Erreur" } | Select-Object timegenerated, @{LABEL = “Échec de l'installation”; EXPRESSION = { $_.productname }}| Format-Table -AutoSize -Wrap | Out-File $Wlogs\WindowsUpdateErreur.txt ;
# List Installed Software Event Log
Get-WinEvent -ProviderName msiinstaller | Where-Object id -eq 1033 | Select-Object timecreated,message | Format-List * |  Out-File $env:USERPROFILE\Desktop\InfoSys\Software\InstalledSoftwareWinEvent.txt ;
#Writing to Host
Move-Item "C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-*" $Network
$Pilotes = "$env:USERPROFILE\Desktop\InfoSys\Pilotes"
New-Item -ItemType Directory -Path $Pilotes
Move-Item -Path $env:USERPROFILE\Desktop\WindowsUpdate.log $Wlogs
Write-Host "Computer Full DriverInfo" -ForegroundColor Cyan
Write-Output "Computer Full DriverInfo"
Get-PnpDevice -PresentOnly | Select-Object -Property Status,Friendlyname,InstanceId | Format-Table -GroupBy Status | Out-File $Pilotes\DriverVendorID.txt ; 
Get-CimInstance Win32_PnPEntity | Select-Object Status, Class, FriendlyName, instanceId | Format-Table -GroupBy Status | Out-File $Pilotes\DriverStatus.txt ; 
Get-WmiObject Win32_PnPSignedDriver| Select-Object DeviceName, Manufacturer, DriverVersion | Out-File $Pilotes\DriverVersion.txt ;  
Get-WmiObject -Class Win32_PnpEntity -ComputerName localhost -Namespace Root\CIMV2 | Where-Object {$_.ConfigManagerErrorCode -gt 0 } | Select-Object ConfigManagerErrorCode,Errortext,Present,Status,StatusInfo,caption | Format-List -GroupBy Status  | Out-File $Pilotes\DriverError.txt
Compress-Archive -Path "$env:userprofile\desktop\InfoSys" -DestinationPath "$env:userprofile\desktop\InfoSys.zip" -Update

#Remove-Item -Path infosys.ps1
Remove-Item $env:userprofile\desktop\InfoSys -Recurse
Write-Host "Exportation des taches Terminer !!!." -ForegroundColor Green
Write-Host ""
Write-Host "Le dossier se trouve sur le bureau" -ForegroundColor Red
#Clear-Host
timeout.exe 5
Exit

