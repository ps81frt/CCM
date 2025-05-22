New-Item -Path "$env:userprofile\Desktop\" -Name "Diag" -ItemType Directory -Update;
New-Item -Path "$env:userprofile\Desktop\Diag\" -Name "Application" -ItemType Directory -Update;
New-Item -Path "$env:userprofile\Desktop\Diag\" -Name "Systeme" -ItemType Directory -Update;

# Configguration Système:

&{gwmi Win32_OperatingSystem | Select Caption, BuildNumber, Version, SystemDirectory |fl ; 
gwmi -Class Win32_BaseBoard | Format-List Product,Manufacturer, SerialNumber, Version ; 
gwmi -Class Win32_BIOS | Select-Object BIOSVersion,Manufacturer,SMBIOSBIOSVersion | fl  ; 
Get-CimInstance Win32_Processor | fl ; 
gwmi -ClassName win32_VideoController | Select-Object Description,DriverVersion,AdapterCompatibility,InfFilename,VideoModeDescription  | Format-List ; 
gwmi Win32_PhysicalMemory | Format-Table Manufacturer, SerialNumber, BankLabel, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}; align="center"}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}; align="center"} -Auto ; 
Get-PhysicalDisk ; 
wmic /namespace:\\root\wmi path MSStorageDriver_FailurePredictStatus ; 
wmic startup get caption,command ; Get-WmiObject win32_service | where { $_.Caption -notmatch "Microsoft" -and $_.PathName -notmatch "Windows" } | Select-Object Name,Startmode,State,Status,ExitCode,ProcessId,DisplayName | Sort-Object -Property @{Expression = "Name" } |ft } | Out-File -Width 4096  $env:USERPROFILE\desktop\Diag\CONFIG_System.txt -Update;

# Apllication:

Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1000 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1000.txt -Update;
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1001 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1001.txt -Update;
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1005 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1005.txt -Update;
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1026 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1026.txt -Update;

# Event Apllications installer:

Get-WinEvent -FilterHashtable @{ LogName = "Application"; ID = 1033 } | Select timecreated,level,message | Select -First 140 | Format-List | Out-File $env:userprofile\Desktop\Diag\Application\LogAppliInstaller_1033.txt -Update;

# Système:

Write-Host "100 dernier evenement du journal system" ; Get-WinEvent -LogName System  -MaxEvents 100 | Select-Object TimeCreated,UserId,ContainerLog,ID,Level,Message,ProviderName,MachineName,TaskDisplayName,ProcessId,RecordId,Version,Task,Keywords | fl| fl | Out-File -FilePath $env:USERPROFILE\Desktop\Diag\Systeme\eventsystem2.txt -Update;
Get-EventLog -LogName System  -After (Get-Date).AddDays(-4) -EntryType Error, Warning | Select-Object -First 100 | fl | Out-File -FilePath $env:USERPROFILE\Desktop\Diag\Systeme\eventsystem.txt -Update
