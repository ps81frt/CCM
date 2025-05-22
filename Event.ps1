New-Item -Path "$env:userprofile\Desktop\" -Name "Diag" -ItemType Directory;
New-Item -Path "$env:userprofile\Desktop\Diag\" -Name "Application" -ItemType Directory;
New-Item -Path "$env:userprofile\Desktop\Diag\" -Name "Systeme" -ItemType Directory;

# Apllication:

Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1000 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1000.txt;
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1001 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1001.txt;
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1005 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1005.txt;
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1026 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1026.txt;

# Système:

Write-Host "100 dernier evenement du journal system" ; Get-WinEvent -LogName System  -MaxEvents 100 | Select-Object TimeCreated,UserId,ContainerLog,ID,Level,Message,ProviderName,MachineName,TaskDisplayName,ProcessId,RecordId,Version,Task,Keywords | fl| fl | Out-File -FilePath $env:USERPROFILE\Desktop\Diag\Systeme\
eventsystem2.txt;
Get-EventLog -LogName System  -After (Get-Date).AddDays(-4) -EntryType Error, Warning | Select-Object -First 100 | fl | Out-File -FilePath $env:USERPROFILE\Desktop\Diag\Systeme\eventsystem.txt
