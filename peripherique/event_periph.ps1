# Périphérique:


Get-WinEvent -LogName Security -MaxEvents 1000 -Verbose | Where-Object { $_.ID -eq 20001 -and $_.ID -eq 20003 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag_result\Peripherique\Log_install_periph.txt ;
Get-WinEvent -LogName Security -MaxEvents 1000 -Verbose | Where-Object { $_.ID -eq 6416 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag_result\Peripherique\Log_Drive_Coonection.txt ;
Get-WinEvent -LogName Security -MaxEvents 1000 -Verbose | Where-Object { $_.ID -eq 4663 } | Format-List  TimeCreated, AppName,  ProviderName, Id, Message | Out-File $env:userprofile\Desktop\Diag_result\Peripherique\log_drive_access.txt

