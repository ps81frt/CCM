# Ce script s execute avec powershell 7
# pour verifier quelle version vous utiliser executer:
# 
#       $PSVersionTable


$paths = "$env:userprofile\Desktop\Reseau_Pilotes.zip", "$env:userprofile\Desktop\Reseau_Pilotes"
foreach ($path in $paths) {
    if (Test-Path -LiteralPath $path) {
      Remove-Item -LiteralPath $path -Verbose -Recurse -WhatIf
    } else {
      "Le dossier: $path n existe pas"
    }
}

New-Item -Path "$env:userprofile\Desktop\" -Name "Reseau_Pilotes" -ItemType Directory ;
New-Item -Path "$env:userprofile\Desktop\Reseau_Pilotes" -Name "Pilotes" -ItemType Directory ;
New-Item -Path "$env:userprofile\Desktop\Reseau_Pilotes" -Name "Rapport_reseau" -ItemType Directory ; 


&{Get-NetAdapter -Name "Wi*" -IncludeHidden | Format-Table -Property "Name", "InterfaceDescription", "InterfaceName" , "ifIndex", "LinkSpeed" ; netsh interface tcp show global ; Get-CimInstance win32_networkadapterconfiguration -computer $computer | Where-Object { $null -ne $_.IPAddress } | Select-Object IPAddress, DefaultIPGateway, DNSServerSearchOrder, IPSubnet, Caption, DHCPEnabled, DHCPServer, DNSDomainSuffixSearchOrder | Format-List ; ping -s 2 8.8.8.8 ; Test-Connection 8.8.4.4 }| Out-File "$env:USERPROFILE\Desktop\Reseau_Pilotes\Rapport_reseau\NetworkInfo.txt" ;
#netsh wlan show wlanreport 
#Move-Item -Path "C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html" -Destination "$env:USERPROFILE\Desktop\Reseau_Pilotes\Rapport_reseau"
#Rename-Item -Path "$env:USERPROFILE\Desktop\Reseau_Pilotes\Rapport_reseau\wlan-report-latest.html" -NewName "Priver_Rapport_Wi-fi.html"

&{Get-PnpDevice | Select-Object -Property Status,Friendlyname,InstanceId | Format-Table -GroupBy Status ; Get-WmiObject Win32_PnPSignedDriver| Select-Object DeviceName, Manufacturer, DriverVersion ;Get-WmiObject -Class Win32_PnpEntity -ComputerName localhost -Namespace Root\CIMV2 | Where-Object {$_.ConfigManagerErrorCode -gt 0 } | Select-Object ConfigManagerErrorCode,Errortext,Present,Status,StatusInfo,caption | Format-List -GroupBy Status  } | Out-File "$env:USERPROFILE\Desktop\Reseau_Pilotes\Pilotes\Pilotes.txt"

Compress-Archive -Path "$env:userprofile\Desktop\Reseau_Pilotes" -DestinationPath "$env:userprofile\Desktop\Reseau_Pilotes.zip" -Force
Remove-Item "$env:userprofile\Desktop\Reseau_Pilotes" -Recurse
Write-Host "Exportation des taches Terminer !!!." -ForegroundColor Green
Write-Host ""
Write-Host "Le dossier se trouve sur le bureau" -ForegroundColor Red
#Clear-Host
timeout.exe 5
Exit
cls