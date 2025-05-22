## * Activation des logs plug'n'play périphériques:

			auditpol /set /subcategory:"Événements Plug-and-Play" /success:enable
			auditpol /set /option:CrashOnAuditFail /value:enable

### * Lorsqu'un nouveau périphérique USB ou Plug and Play est connecté, Windows installe un pilote.


>Id 6416 enregistre chaque fois qu'un périphérique Plug and Play est ajouté.

>Id 4663 est enregistré lorsque des fichiers ou des dossiers sur un périphérique amovible sont consultés, créés ou modifiés

### * Log nouveau périphérique:

>Id 20001 (début de l'installation)

>Id 20003 (achèvement de l'installation)
