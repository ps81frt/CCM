New-Item -Path "$env:userprofile\Desktop\" -Name "Diag" -ItemType Directory
New-Item -Path "$env:userprofile\Desktop\Diag\" -Name "Application" -ItemType Directory

# Apllication:

Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1000 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1000.txt
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1001 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1001.txt
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1005 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1005.txt
Get-WinEvent -LogName Application -MaxEvents 1000 -Verbose | Where { $_.ID -eq 1026 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag\Application\apli_1026.txt

# Système:
