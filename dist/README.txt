Servidor Amiguos - Modpack
=======================

Modpack privado de Minecraft 1.21.1 + NeoForge 21.1.234.
Server: amiguos.holy.gg (no-premium)
Launcher: TLauncher (no-premium, estandar para no-premium en Latam)

INSTALACION (una sola vez)
---------------------------

Windows:
  1. Descomprime este ZIP donde quieras
  2. Doble click en launcher.bat
     (descarga la ultima version del instalador)
  3. Espera a que se instale: Java 21, TLauncher, los 39 mods (~91 MB),
     y se cree la instancia "Servidor Amiguos" en TLauncher
  4. Abre TLauncher desde el acceso directo del escritorio
  5. Click en la instancia "Servidor Amiguos"
  6. Login con cualquier username (sin password) y click "Entrar al juego"
  7. Click Play, conectate a amiguos.holy.gg

Mac:
  1. Descomprime este ZIP donde quieras
  2. Abre Terminal en la carpeta descomprimida
  3. Ejecuta: bash launcher.sh
  4. Espera a que se instale: Java 21, TLauncher (en ~/Library/Application
     Support/TLauncher/), los 39 mods, y se cree la instancia
  5. Abre TLauncher desde ~/Library/Application Support/TLauncher/TLauncher.command
  6. Click en la instancia "Servidor Amiguos"
  7. Login con cualquier username, click "Entrar al juego", conectate al server

Linux:
  1. Descomprime este ZIP donde quieras
  2. Abre Terminal en la carpeta descomprimida
  3. Ejecuta: bash launcher.sh
  4. Espera a que se instale Java 21, TLauncher (en ~/.local/share/TLauncher/),
     los 39 mods, y se cree la instancia
  5. Abre TLauncher desde ~/.local/share/TLauncher/tlauncher
  6. Click en la instancia "Servidor Amiguos"
  7. Login con cualquier username, click "Entrar al juego", conectate al server

CREAR CUENTA EN TLAUNCHER
-------------------------

Al abrir TLauncher por primera vez:
  1. Click "Entrar al juego" o "Login"
  2. Te pide un username (cualquiera) y password (cualquiera, no valida)
  3. Click "Entrar"
  4. Listo, ya podes jugar

INSTANCIA YA CREADA
---------------------

El script creo la instancia "Servidor Amiguos" (1.21.1 + NeoForge 21.1.234) en
TLauncher con los 39 mods pre-instalados. Solo:
  1. Click en la instancia "Servidor Amiguos"
  2. Click "Entrar al juego" (o Login si no has entrado)
  3. Click "Play"
  4. En Minecraft: Multiplayer -> Add Server -> amiguos.holy.gg -> Join Server

Si la instancia no se creo automaticamente, creala manual:
  1. Click "+" o "Add Instance"
  2. Configura: 1.21.1 + NeoForge 21.1.234
  3. Click "OK" / "Create"

UPDATES
-------

Cada vez que quieras buscar updates:
  - Windows: doble-click el acceso directo "Servidor Amiguos - Actualizar" del escritorio
  - Mac/Linux: ejecuta launcher.sh (o launcher.bat) de nuevo

Los mods y configs se actualizan solos en la instancia de TLauncher.

PROBLEMAS COMUNES
-----------------

"No se pudo instalar TLauncher" (Windows)
  -> El instalador .exe puede requerir permisos de admin
  -> O baja desde https://tlauncher.org/en/ y ejecuta el instalador

"No se creo la instancia automaticamente"
  -> Verifica que TLauncher este instalado en %APPDATA%\TLauncher\ (Windows)
  -> Crealo manual: Add Instance -> 1.21.1 + NeoForge 21.1.234

"Java not found" o "Version 21 not found"
  -> El launcher deberia instalar Java 21 portable automaticamente
  -> Si falla, descarga desde https://adoptium.net/

"Mods no aparecen"
  -> Verifica que NeoForge 21.1.234 esta seleccionado en la instancia
  -> Ejecuta el launcher.bat de nuevo para re-descargar mods

"Failed to connect to server"
  -> Verifica que el server esta corriendo (pregunta al admin)
  -> Verifica tu conexion a internet

"El server dice 'You are not whitelisted'"
  -> No estas en la whitelist del server
  -> Contacta al admin para que te agregue
