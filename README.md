# Infos_Forensic
>------------------------------------------------------------------------------------------------------------------------------------------
### Télécharger sur GitHub



![git](https://github.com/user-attachments/assets/6cd483d7-653a-45e2-8c36-033a75dbeb21)






>------------------------------------------------------------------------------------------------------------------------------------------

*
*


## Avant le lancer les script il vous faudra les authoriser.

            set-executionpolicy unrestricted
*
*

## Le script Event.ps1 doit se lancer via Powershell 5 eclui installé par defaut dans windows
>------------------------------------------------------------------------------------------------------------------------------------------

                        DOSSIER DIAG SUR LE BUREAU
                        Format Zip
*
*

## Le Script Infosys.ps1 doit se lancer avec powershell 7 s'il n'est pas encore installé je vous invite a le faire.
>------------------------------------------------------------------------------------------------------------------------------------------

                        DOSSIER INFOSYS SUR LE BUREAU
                        Format Zip


Installation & Mise a jours de Powershell 7
>------------------------------------------------------------------------------------------------------------------------------------------


      $PSVersionTable.PSVersion
      iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
      dotnet tool update --global PowerShell
      $PSVersionTable



                                
<a href="https://learn.microsoft.com/fr-fr/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5" rel="nofollow">Installation de PowerShell sur Windows 7</a>
