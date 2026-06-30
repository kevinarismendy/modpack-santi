Servidor Amiguos - Modpack
=======================

Modpack privado de Minecraft 1.21.1 + NeoForge 21.1.234.
Server: amiguos.holy.gg (no-premium)
Launcher: HMCL (no-premium, open source, soporta offline)

INSTALACION (una sola vez)
---------------------------

Windows:
  1. Descomprime este ZIP donde quieras
  2. Doble click en launcher.bat
     (descarga la ultima version del instalador)
  3. Espera a que se instale: Java 21, HMCL, y los ~91 MB de mods
  4. Abrir HMCL desde el acceso directo del escritorio
  5. Crear cuenta offline (ver instrucciones mas abajo)
  6. Crear instancia 1.21.1 + NeoForge
  7. Conectar a amiguos.holy.gg

Mac:
  1. Descomprime este ZIP donde quieras
  2. Abre Terminal en la carpeta descomprimida
  3. Ejecuta: bash launcher.sh
  4. Espera a que se instale Java 21, HMCL, y los ~91 MB de mods
  5. Abrir HMCL desde ~/Library/Application Support/HMCL/HMCL.command
  6. Crear cuenta offline
  7. Crear instancia 1.21.1 + NeoForge
  8. Conectar a amiguos.holy.gg

Linux:
  1. Descomprime este ZIP donde quieras
  2. Abre Terminal en la carpeta descomprimida
  3. Ejecuta: bash launcher.sh
  4. Espera a que se instale Java 21, HMCL, y los ~91 MB de mods
  5. Abrir HMCL desde ~/Library/Application Support/HMCL/HMCL.sh
  6. Crear cuenta offline
  7. Crear instancia 1.21.1 + NeoForge
  8. Conectar a amiguos.holy.gg

CREAR CUENTA OFFLINE EN HMCL
---------------------------

Al abrir HMCL por primera vez:
  1. Te aparece la pantalla principal
  2. Click en el icono de persona (esquina superior) o "Add Account"
  3. Selecciona "Classic Account" (NO Microsoft Account)
  4. Escribe:
     - Username: cualquier nombre (ej: tu nombre, Steve123)
     - Password: cualquier cosa (no se valida)
  5. Click "Add" o "OK"
  6. La cuenta aparece en la lista, ya podes jugar

CREAR INSTANCIA 1.21.1 + NEOFORGE
-----------------------------------

1. En HMCL, click "+" o "Add Instance"
2. Configura:
   - Name: Servidor Amiguos (o lo que quieras)
   - Version: 1.21.1
   - Loader: NeoForge
   - Loader Version: 21.1.234
3. Click "OK" o "Create"
4. Espera a que baje NeoForge (1-2 min la primera vez)
5. Los mods ya estan instalados por el launcher
6. Launch / Play

CONECTAR AL SERVER
-------------------

En Minecraft:
  1. Main Menu -> Multiplayer
  2. Add Server
  3. Server Name: Servidor Amiguos
  4. Server Address: amiguos.holy.gg
  5. Click "Done" / "Join Server"

UPDATES
-------

Cada vez que quieras buscar updates:
  - Windows: doble-click el acceso directo "Servidor Amiguos - Actualizar" del escritorio
  - Mac/Linux: ejecuta launcher.sh (o launcher.bat) de nuevo

Los mods y configs se actualizan solos.

PROBLEMAS COMUNES
-----------------

"No se pudo instalar HMCL" (Windows)
  -> Abre PowerShell como admin y corre: winget install --exact --id HMCL.HMCL.Stable
  -> O descarga desde https://hmcl.huangyuhui.net/download/

"Java not found" o "Version 21 not found"
  -> El launcher deberia instalar Java 21 portable automaticamente
  -> Si falla, descarga desde https://adoptium.net/

"Mods no aparecen"
  -> Asegurate de tener NeoForge 21.1.234 instalado en la instancia
  -> Verifica que la instancia es 1.21.1 (no 1.20.x o 1.21.2)

"Failed to connect to server"
  -> Verifica que la IP del server es correcta
  -> Verifica que el server esta corriendo (pregunta al admin)
  -> Verifica tu conexion a internet

"No me deja agregar cuenta"
  -> Asegurate de seleccionar "Classic Account", NO "Microsoft Account"
  -> Si ya tienes una cuenta de Microsoft, la opcion offline no aparecera
  -> Solucion: desinstala HMCL, borra %APPDATA%\HMCL, reinstala

"El server dice 'You are not whitelisted'"
  -> No estas en la whitelist del server
  -> Contacta al admin para que te agregue
