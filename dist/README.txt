Servidor Amiguos - Modpack
=======================

Modpack privado de Minecraft 1.21.1 + NeoForge 21.1.234.
Server: amiguos.holy.gg (no-premium)
Launcher: HMCL (no-premium, soporta NeoForge, open source GPL-3.0)

INSTALACION (una sola vez)
---------------------------

Windows:
  1. Descomprime este ZIP donde quieras
  2. Doble click en launcher.bat
     (descarga la ultima version del instalador)
  3. Espera a que se instale: Java 21, HMCL, los 39 mods (~91 MB),
     y se cree la instancia "Servidor Amiguos" en HMCL
  4. Abre HMCL desde el acceso directo del escritorio
  5. Click en la instancia "Servidor Amiguos"
  6. Login con cualquier username (sin password) y click "Entrar al juego"
  7. Click Play, conectate a amiguos.holy.gg

Mac:
  1. Descomprime este ZIP donde quieras
  2. Abre Terminal en la carpeta descomprimida
  3. Ejecuta: bash launcher.sh
  4. Espera a que se instale: Java 21, HMCL (en ~/Library/Application
     Support/HMCL/), los 39 mods, y se cree la instancia
  5. Abre HMCL desde ~/Library/Application Support/HMCL/HMCL.command
  6. Click en la instancia "Servidor Amiguos"
  7. Login con cualquier username, click "Entrar al juego", conectate al server

Linux:
  1. Descomprime este ZIP donde quieras
  2. Abre Terminal en la carpeta descomprimida
  3. Ejecuta: bash launcher.sh
  4. Espera a que se instale Java 21, HMCL (en ~/.local/share/HMCL/),
     los 39 mods, y se cree la instancia
  5. Abre HMCL desde ~/.local/share/HMCL/HMCL
  6. Click en la instancia "Servidor Amiguos"
  7. Login con cualquier username, click "Entrar al juego", conectate al server

CREAR CUENTA OFFLINE EN HMCL
-----------------------------

Al abrir HMCL por primera vez:
  1. Te aparece la pantalla principal
  2. Click en el icono de persona (esquina superior) o "Add Account"
  3. Selecciona "Classic Account" (no Microsoft)
  4. Te pide:
     - Username: cualquiera (ej: tu nombre)
     - Password: cualquiera (no se valida)
  5. Click "Add" o "OK"
  6. Listo, ya podes jugar

INSTANCIA YA CREADA
---------------------

El script creo la instancia "Servidor Amiguos" (1.21.1 + NeoForge 21.1.234) en
HMCL con los 39 mods pre-instalados. Solo:
  1. Click en la instancia "Servidor Amiguos"
  2. Click "Entrar al juego" (o Login si no has entrado)
  3. Click "Play"
  4. En Minecraft: Multiplayer -> Add Server -> amiguos.holy.gg -> Join Server

Si la instancia no se creo automaticamente, creala manual:
  1. Click "+" o "Add Instance"
  2. Configura: 1.21.1 + NeoForge 21.1.234
  3. Click "OK" / "Create"
  4. Despues de crear la instancia, copia los 39 mods de la carpeta
     `dist-tlauncher/mods/` (del ZIP) a la instancia .minecraft/mods/

UPDATES
-------

Cada vez que quieras buscar updates:
  - Windows: doble-click el acceso directo "Servidor Amiguos - Actualizar" del escritorio
  - Mac/Linux: ejecuta launcher.sh (o launcher.bat) de nuevo

Los mods y configs se actualizan solos en la instancia de HMCL.

PROBLEMAS COMUNES
-----------------

"No se pudo instalar HMCL" (Windows)
  -> El instalador puede requerir permisos de admin
  -> O baja desde https://hmcl.huangyuhui.net/download/ y ejecuta el .exe

"No se creo la instancia automaticamente"
  -> Verifica que HMCL este instalado en %APPDATA%\.hmcl\ (Windows)
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

"HMCL pide Microsoft account"
  -> Asegurate de seleccionar "Classic Account", NO "Microsoft Account"
  -> Si ya tienes cuenta MS, desinstala HMCL y borra %APPDATA%\.hmcl

¿POR QUE HMCL Y NO TLAUNCHER?
------------------------

Probamos TLauncher primero pero NO soporta NeoForge. Solo Forge, Fabric,
Quilt, OptiFine. Sin NeoForge, 24 de 39 mods no funcionan. HMCL es open
source, soporta NeoForge, y permite cuentas "Classic" (no-premium). Es la
unica opcion que soporta todo el modpack.

TLauncher 1.x: Forge, Fabric, Quilt, OptiFine (sin NeoForge)
TLauncher 2.x: similar (no testeado completamente)
HMCL: Forge, NeoForge, Fabric, OptiFine (soporta todo)
Prism: Forge, NeoForge, Fabric, OptiFine (pero requiere Microsoft account)
