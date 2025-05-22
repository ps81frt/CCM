# CCM
>------------------------------------------------------------------------------------------------------------------------------------------


## Le script Event.ps1 doit se lancer via Powershell 5 eclui installé par defaut dans windows
>------------------------------------------------------------------------------------------------------------------------------------------


## Le Script Infosys.ps1 doit se lancer avec powershell 7 s'il n'est pas encore installé je vous invite a le faire.
>------------------------------------------------------------------------------------------------------------------------------------------

Installation & Mise a jours de Powershell 7
>------------------------------------------------------------------------------------------------------------------------------------------


      $PSVersionTable.PSVersion
      iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
      dotnet tool update --global PowerShell
      $PSVersionTable



                                
<a href="https://learn.microsoft.com/fr-fr/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5" rel="nofollow">Installation de PowerShell sur Windows</a>
