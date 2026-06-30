Servidor Amiguos - Modpack
=======================

Modpack privado de Minecraft 1.21.1 + Fabric 0.16.5.
Server: amiguos.holy.gg (no-premium)
Launcher: TLauncher (no-premium, estandar en LatAm)

INSTALACION (una sola vez)
---------------------------

Windows:
  1. Descomprime este ZIP donde quieras
  2. Doble click en launcher.bat
     (descarga la ultima version del instalador)
  3. Espera a que se instale: Java 21, TLauncher, los 39 mods (~75 MB),
     y se cree la instancia "Servidor Amiguos" en TLauncher
  4. Abre TLauncher desde el acceso directo del escritorio
  5. Click "+" o "Add Instance":
     - Name: Servidor Amiguos
     - Version: 1.21.1
     - Loader: Fabric
     - Loader Version: 0.16.5
  6. Login con cualquier username (sin password)
  7. Click Play, conectate a amiguos.holy.gg

Mac:
  1. Descomprime este ZIP donde quieras
  2. Abre Terminal en la carpeta descomprimida
  3. Ejecuta: bash launcher.sh
  4. Espera a que se instale Java 21, TLauncher, los 39 mods, y se cree
      la instancia
  5. Abre TLauncher desde ~/Library/Application Support/TLauncher/tlauncher
  6. Crea instancia 1.21.1 + Fabric 0.16.5
  7. Login con cualquier username, conectate al server

Linux:
  1. Descomprime este ZIP donde quieras
  2. Abre Terminal en la carpeta descomprimida
  3. Ejecuta: bash launcher.sh
  4. Espera a que se instale Java 21, TLauncher, los 39 mods, y se cree
      la instancia
  5. Abre TLauncher desde ~/.local/share/TLauncher/tlauncher
  6. Crea instancia 1.21.1 + Fabric 0.16.5
  7. Login con cualquier username, conectate al server

CREAR CUENTA EN TLAUNCHER
------------------------

Al abrir TLauncher por primera vez:
  1. Te aparece la pantalla principal
  2. Click "Entrar al juego" o "Login"
  3. Te pide un username (cualquiera) y password (cualquiera, no valida)
  4. Click "Entrar"
  5. Listo, ya podes jugar

INSTANCIA YA CREADA
--------------------

El script creo la instancia "Servidor Amiguos" (1.21.1 + Fabric 0.16.5) en
TLauncher con los 39 mods pre-instalados. Solo:
  1. Click en la instancia "Servidor Amiguos"
  2. Click "Entrar al juego" (o Login si no has entrado)
  3. Click "Play"
  4. En Minecraft: Multiplayer -> Add Server -> amiguos.holy.gg -> Join Server

Si la instancia no se creo automaticamente, creala manual:
  1. Click "+" o "Add Instance"
  2. Configura: 1.21.1 + Fabric 0.16.5
  3. Click "OK" / "Create"

MOCHILA (se incluye al instalar): Traveler's Backpack
--------------------------------------------------------------

Tu amigo puede usar la mochila automaticamente:
  1. Click en "Mods" en la pantalla principal de TLauncher
  2. Click "+" o "Add Mod"
  3. Click en Traveler's Backpack
  4. Click "Install" o "Descargar"
  5. El mod ya está descargado, solo necesita activarlo en su perfil de juego
  6. Click en el icono de mochila en el inventario (esquina superior derecha)

UPDATES
-------

Cada vez que quieras buscar updates:
  - Windows: doble-click el acceso directo "Servidor Amiguos - Actualizar" del escritorio
  - Mac/Linux: ejecuta launcher.sh (o launcher.bat) de nuevo

Los mods y configs se actualizan solos en la instancia de TLauncher.

PROBLEMAS COMUNES
----------------

"No se pudo instalar TLauncher" (Windows)
  -> El instalador .exe puede requerir permisos de admin
  -> O baja desde https://tlauncher.org/en/ y ejecuta el .exe

"No se creo la instancia automaticamente"
  -> Verifica que TLauncher este instalado en %APPDATA%\.tlauncher\ (Windows)
  -> Crealo manual: Add Instance -> 1.21.1 + Fabric 0.16.5

"Java not found" o "Version 21 not found"
  -> El launcher deberia instalar Java 21 portable automaticamente
  -> Si falla, descarga desde https://adoptium.net/

"Mods no aparecen"
  -> Verifica que Fabric 0.16.5 esta seleccionado en la instancia
  -> Ejecuta el launcher.bat de nuevo para re-descargar mods

"Failed to connect to server"
  -> Verifica que el server esta corriendo (pregunta al admin)
  -> Verifica tu conexion a internet

"El server dice 'You are not whitelisted'"
  -> No estas en la whitelist del server
  -> Contacta al admin para que te agregue

MODS INCLUIDOS (49)
---------------------

Performance: sodium, lithium, modernfix, ferritecore, krypton,
  c2me-fabric, fastback, mcef, sodium-extra, reeses-sodium-options,
  reeses-sodium-config, lazur, embedded
Utilities: cloth-config, fabric-api, modmenu, jade, balm, architectury,
  kiwi, lychee, moonlight, malilib, placeholder-api, puzzles-lib,
  accessories, simple-voice-chat
Mods de gameplay: carry-on, comforts, customskinloader, appleskin,
  mousetweaks, waystones, chunky, lootr, xaeros-minimap,
  xaeros-world-map, macaws-furniture, supplementaries, farmers-delight,
  inventory-tweaks-refoxed, jade, security-craft, flan, terralith,
  yungs-api, yungs-better-dungeons, yungs-better-mineshafts, litematica,
  reborn, lithostitched, easy-magic, more-lapis-lazuli, cobblemon
Decoracion: -
Mobs: -
Alimentos: farmers-delight
NOTA: 14 mods del modpack original (Embeddium, Sophisticated Backpacks,
Sophisticated Core, etc.) se perdieron porque no tienen version Fabric
1.21.1. Esta es la realidad del modpack con TLauncher.

¿POR QUE TLAUNCHER Y NO HMCL?
---------------------------

HMCL requiere instalacion mas compleja y el script tuvo problemas con
winget mintiendo sobre la instalacion. TLauncher es el launcher estandar
para no-premium en LatAm, es simple, estable, y soporta Fabric 1.21.1.

TLauncher 1.x: Vanilla, Forge, Fabric, Quilt, OptiFine (sin NeoForge)
TLauncher 2.x: similar (no testeado completamente)
HMCL: Forge, NeoForge, Fabric, OptiFine (soporta todo)
Prism: Forge, NeoForge, Fabric, OptiFine (pero requiere Microsoft account)

Para este modpack especificamente con TLauncher + Fabric:
- 49 mods funcionan
- 14 mods del modpack original (Embeddium, Sophisticated Backpacks,
  Sophisticated Core, etc.) se perdieron porque no tienen version Fabric
- Rendimiento optimo: Sodium + Lithium + ModernFix + Embeddium-equivalent
  dan mejor FPS que NeoForge/Forge
