New-Item -Path "$env:userprofile\Desktop\" -Name "Diag" -ItemType Directory ;
New-Item -Path "$env:userprofile\Desktop\Diag\" -Name "Application" -ItemType Directory ;
New-Item -Path "$env:userprofile\Desktop\Diag\" -Name "Systeme" -ItemType Directory ;
New-Item -Path "$env:userprofile\Desktop\Diag\" -Name "periph" -ItemType Directory ;


# Configuration Système Mini:

&{gwmi Win32_OperatingSystem | Select-Object Caption, BuildNumber, Version, SystemDirectory | Format-List ; 
gwmi -Class Win32_BaseBoard | Format-List Product,Manufacturer, SerialNumber, Version ; 
gwmi -Class Win32_BIOS | Select-Object BIOSVersion,Manufacturer,SMBIOSBIOSVersion | Format-List  ; 
Get-CimInstance Win32_Processor | Format-List ; 
gwmi -ClassName win32_VideoController | Select-Object Description,DriverVersion,AdapterCompatibility,InfFilename,VideoModeDescription  | Format-List ; 
gwmi Win32_PhysicalMemory | Format-Table Manufacturer, SerialNumber, BankLabel, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}; align="center"}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}; align="center"} -Auto ; 
Get-PhysicalDisk ; 
wmic /namespace:\\root\wmi path MSStorageDriver_FailurePredictStatus ; 
wmic startup get caption,command ; Get-WmiObject win32_service | Where-Object { $_.Caption -notmatch "Microsoft" -and $_.PathName -notmatch "Windows" } | Select-Object Name,Startmode,State,Status,ExitCode,ProcessId,DisplayName | Sort-Object -Property @{Expression = "Name" } | Format-List } | Out-File -Width 4096  $env:USERPROFILE\desktop\Diag\CONFIG_System.txt ;

# Application:

Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where-Object { $_.ID -eq 1000 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1000.txt ;
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where-Object { $_.ID -eq 1001 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1001.txt ;
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where-Object { $_.ID -eq 1005 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1005.txt ;
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where-Object { $_.ID -eq 1026 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1026.txt ;

# Event Applications installer:

Get-WinEvent -FilterHashtable @{ LogName = "Application"; ID = 1033 } | Select-Object timecreated,level,message | Select-Object -First 140 | Format-List | Out-File $env:userprofile\Desktop\Diag\Application\LogAppliInstaller_1033.txt ;

# Système:

Write-Host "100 dernier evenement du journal system" ;
Get-WinEvent -LogName System  -MaxEvents 100 | Select-Object TimeCreated,UserId,ContainerLog,ID,Level,Message,ProviderName,MachineName,TaskDisplayName,ProcessId,RecordId,Version,Task,Keywords | Format-List | Out-File -FilePath $env:USERPROFILE\Desktop\Diag\Systeme\eventsystem2.txt ;
Get-EventLog -LogName System  -After (Get-Date).AddDays(-4) -EntryType Error, Warning | Select-Object -First 100 | Format-List | Out-File -FilePath $env:USERPROFILE\Desktop\Diag\Systeme\eventsystem.txt

# Backup:

Compress-Archive -Path "$env:userprofile\desktop\Diag" -DestinationPath "$env:userprofile\desktop\Diag.zip" -Update
Remove-Item $env:userprofile\desktop\Diag -Recurse

