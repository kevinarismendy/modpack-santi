# Servidor Amiguos

Modpack privado de Minecraft 1.21.1 + Fabric 0.16.5 para 10 amigos.

## Configuración
- **Server:** HolyHosting (16GB RAM, 2 cores Ryzen)
- **Mod loader:** Fabric 0.16.5
- **Launcher:** TLauncher (no-premium, estandar en LatAm)
- **Mochila:** Traveler's Backpack (auto-instalado, se activa desde mods en TLauncher)
- **Server:** amiguos.holy.gg

## Por qué TLauncher + Fabric

TLauncher es el launcher no-premium mas popular en LatAm (simple, estable, portable). Soporta Fabric 1.21.1 nativamente, que es el loader moderno con mejor rendimiento (Sodium + Lithium + mods de optimizacion).

## Para los amigos

### Una sola vez
1. Recibi el link del admin
2. Baja y descomprime el ZIP (~90KB)
3. Doble-click `launcher.bat` (Windows) o `bash launcher.sh` (Mac/Linux)
4. Espera 3-5 min. El script instala:
   - Java 21 portable (si no lo tiene)
   - TLauncher (descarga el instalador)
   - Los 39 mods (~75 MB)
   - Crea la instancia "Servidor Amiguos" en TLauncher
5. Abre TLauncher (acceso directo en escritorio)
6. Login con cualquier username (sin password)
7. Crea instancia 1.21.1 + Fabric 0.16.5
8. Click Play -> conectate a amiguos.holy.gg

### Updates
Cada vez que el admin agregue un mod o actualice algo:
- Doble-click "Servidor Amiguos - Actualizar" en el escritorio
- O ejecuta `launcher.bat` / `launcher.sh` de nuevo
- Solo se bajan los mods que cambiaron

## Mods Indiscutibles (los que el admin quiere)

| Mod | Categoria | Funcion |
|---|---|---|
| simple-voice-chat | Voz | Chat de voz por proximidad |
| sodium + lithium + modernfix + ferritecore | Rendimiento | 4 mods de optimizacion, ~2x FPS |
| flan | Proteccion | Claim protection de chunks |
| xaeros-minimap | Mapa | Minimapa con waypoints |
| travelersbackpack | Mochila | Mochila equipable con upgrades |
| simple-tpa + ftb-essentials | Comandos | /tpa, /home, /back, etc. |

## Mods totales (39)

### Performance (11)
sodium, sodium-extra, reeses-sodium-options, lithium, modernfix, ferrite-core, krypton, c2me-fabric, fastback, mcef, lazur

### Voz (1)
simple-voice-chat

### Mochila (1)
travelersbackpack

### Proteccion y servidor (4)
flan, lootr, security-craft, simple-tpa

### Mapa y navegacion (3)
xaeros-minimap, xaeros-world-map, waystones

### Mundo (3)
terralith, yungs-better-dungeons, yungs-better-mineshafts

### Construccion y movimiento (4)
chunky, carry-on, comforts, litematica

### Decoracion (4)
supplementaries, macaws-furniture, easy-magic, more-lapis-lazuli

### Mobs (2)
corpse, cobblemon-fight-or-flight-reborn

### UI y HUD (6)
appleskin, mousetweaks, jade, customskinloader, accessories, mouse-tweaks-x-accessories-fix

### Librerias (8)
fabric-api, modmenu, cloth-config, architectury-api, balm, lychee, moonlight, placeholder-api, puzzles-lib

## Estructura del repo

```
kevinarismendy/modpack-santi/
├── pack.toml                          (define modpack: 1.21.1 + Fabric 0.16.5)
├── index.toml                         (catalogo de archivos con hashes)
├── mods/                              (39 archivos .pw.toml con metadata de cada mod)
└── dist/
    ├── launcher.bat                  (descargador de codigo del repo)
    ├── launcher.sh                   (version Mac/Linux)
    ├── install.bat                   (instalador real, descarga e instala todo)
    ├── install.sh                    (version Mac/Linux)
    └── README.txt                    (instrucciones detalladas)
```

## Como funciona el sistema

### Launcher.bat
```
@echo off
set "SCRIPT_URL=https://github.com/kevinarismendy/modpack-santi/releases/latest/download/install.bat"
curl -L -o "%SCRIPT%" "%SCRIPT_URL%"
call "%SCRIPT%"
pause
```
Solo baja el `install.bat` del release mas reciente de GitHub y lo corre. El launcher se auto-actualiza cada vez.

### Install.bat
1. Auto-actualiza el launcher.bat
2. Verifica Java 21 (instala portable de Adoptium si no esta)
3. Instala TLauncher desde `github.com/kevinarismendy/modpack-santi/releases/download/tlauncher-v1/`
4. Crea la instancia "Servidor Amiguos" en `%APPDATA%\.tlauncher\instances\`
5. Corre el `packwiz-installer-bootstrap.jar` con el `pack.toml` del repo (via jsdelivr CDN)
6. El bootstrap baja los 39 mods y los pone en `.minecraft/mods/` de la instancia
7. Crea acceso directo en el escritorio para TLauncher y "Servidor Amiguos - Actualizar"

### Packwiz-installer-bootstrap
- Lee `pack.toml` (define que mod loader y que version de MC)
- Lee `index.toml` (catalogo de archivos con SHA256)
- Por cada archivo: lo baja de la URL especificada en el `.pw.toml`, verifica hash, lo pone en `minecraft/mods/`
- Todo automatico, no necesita interaccion del usuario

## Para los amigos (mas detalle)

### Windows
1. Baja y descomprime `Servidor-Amiguos-Installer.zip`
2. Doble-click `launcher.bat`
3. Espera 3-5 minutos. El script:
   - Verifica si tiene Java 21 (instala portable si no)
   - Instala TLauncher desde nuestro repo
   - Crea la instancia "Servidor Amiguos" en TLauncher
   - Baja los 39 mods via packwiz bootstrap
4. Abre TLauncher desde el acceso directo "Servidor Amiguos - TLauncher" en el escritorio
5. Login con cualquier username (sin password)
6. Click en la instancia "Servidor Amiguos"
7. Click "Entrar al juego" (si no has entrado antes)
8. Click "Play"
9. En Minecraft: Multiplayer -> Add Server -> "amiguos.holy.gg" -> Join Server

### Mac
1. Descomprime el ZIP
2. Abre Terminal en la carpeta descomprimida
3. Ejecuta: `bash launcher.sh`
4. Espera 3-5 min (instala Java + TLauncher + mods + instancia)
5. Abre TLauncher desde `~/Library/Application Support/TLauncher/TLauncher`
6. Mismos pasos que Windows

### Linux
1. Descomprime el ZIP
2. Abre Terminal en la carpeta descomprimida
3. Ejecuta: `bash launcher.sh`
4. Espera 3-5 min
5. Abre TLauncher desde `~/.local/share/TLauncher/tlauncher`
6. Mismos pasos que Windows

## Actualizaciones (para el admin)

Para agregar un mod:
```bash
cd /path/to/Modpack_Santi
./packwiz.exe modrinth install <slug>
./packwiz.exe refresh
git add . && git commit -m "add <slug>" && git push
```

Para re-distribuir (crea nuevo ZIP con la version actualizada):
```powershell
$releases = "C:\Users\kevin\OneDrive\Desktop\Modpack_Santi_Server\Servidor-Amiguos-Installer.zip"
$launchers = "dist\launcher.bat", "dist\launcher.sh", "packwiz-installer-bootstrap.jar", "dist\README.txt"
Compress-Archive -LiteralPath $launchers -DestinationPath $releases -Force
gh release delete v1.x.x -y
gh release create v1.x.x $releases
```

Tu amigo solo necesita doble-click "Servidor Amiguos - Actualizar" en su escritorio.

## Mods Indiscutibles (lo que el admin eligio)

| Mod | Por que |
|---|---|
| simple-voice-chat | Voz por proximidad (lo que el server quiere) |
| sodium + lithium + modernfix + ferritecore | Rendimiento (lo que mantiene el server fluido) |
| flan | Proteccion de chunks (lo que evita grief) |
| xaeros-minimap | Mapa (lo que ayuda a explorar el mundo) |
| travelersbackpack | Mochila (lo que da mas capacidad) |
| simple-tpa + ftb-essentials | Comandos (TPA, home, back) |

## Solución de problemas

### "Java not found"
El launcher deberia instalar Java 21 portable. Si falla, descarga de https://adoptium.net/

### "TLauncher no aparece"
El script descarga TLauncher desde nuestro repo. Si falla, baja desde https://tlauncher.org/en/

### "Mods no aparecen"
Verifica que TLauncher tenga la instancia "Servidor Amiguos" creada con 1.21.1 + Fabric 0.16.5. Click en la instancia -> "Mods" -> ver que los 39 mods esten listados.

### "Failed to connect to server"
Verifica que el server este corriendo. Contacta al admin.

### "Server dice You are not whitelisted"
No estas en la whitelist. Contacta al admin para que te agregue.

### "HMCL no se encuentra"
Usamos TLauncher, no HMCL. Si tu amigo ve un mensaje sobre HMCL, esta viendo una version vieja del README.

## Skins

No hay mod server-side compatible con Fabric 1.21.1 (SkinsRestorer requiere 1.21.11+). El modpack usa **CustomSkinLoader** (client-side). Cada amigo debe poner su skin `.png` en `<instancia>/.minecraft/CustomSkinLoader/local/skins/<username>.png`.

## Configuración técnica

- **pack.toml** define el mod loader (Fabric 0.16.5) y la version de MC (1.21.1)
- **index.toml** es el catalogo de archivos con hashes SHA256
- **packwiz-installer-bootstrap.jar** se incluye en la distribucion (40KB)
- El bootstrap baja los 39 mods desde Modrinth, CurseForge, GitHub releases (segun la URL en cada .pw.toml)

## Como el sistema se auto-actualiza

1. El amigo corre `launcher.bat` -> baja el `install.bat` del release mas reciente
2. Si el admin actualizo el modpack, el `install.bat` baja los mods nuevos
3. El amigo no necesita descargar nada nuevo manualmente

Si el admin agrego un mod nuevo, el amigo lo recibe en su proxima corrida del launcher.
