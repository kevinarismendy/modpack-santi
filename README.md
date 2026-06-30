# Servidor Amiguos - Modpack Installer

Modpack de Minecraft 1.21.1 + Fabric 0.16.5 para 10 amigos.

## Como funciona

El repo se sirve desde **servermc.santiagoarismendy.com** (hosteado en VPS con Coolify).

- El cliente (TLauncher + Fabric) baja los mods desde el VPS
- El servidor de Minecraft (amiguos.holy.gg) corre vanilla Fabric
- Los mods del cliente y servidor son los mismos

## Setup del servidor (Coolify)

1. Crear nuevo **Static Site** o **Application** en Coolify desde el repo de GitHub
2. **Build Command** (en Coolify):
   ```
   echo "Build OK"
   ```
3. **Publish Directory**: `/` (raíz del repo)
4. **Domain**: `servermc.santiagoarismendy.com`
5. **Puerto**: 80

Coolify detecta el `Dockerfile` y lo usa automáticamente.

## Estructura de archivos

```
/
├── Dockerfile              ← build de nginx alpine
├── nginx.conf              ← config con cache-bust para .toml
├── pack.toml               ← entry point del modpack
├── index.toml              ← lista de mods
├── packwiz-installer-bootstrap.jar
├── mods/                   ← 31 .pw.toml (metadata)
│   ├── accessories.pw.toml
│   ├── appleskin.pw.toml
│   └── ...
├── dist/                   ← scripts del cliente (Windows + Mac)
│   ├── Windows/
│   │   ├── 1-instalar-tlauncher.bat
│   │   ├── 2-instalar-mods.bat
│   │   └── 3-accesos-directos.bat
│   └── Mac/
│       ├── 1-instalar-tlauncher.sh
│       ├── 2-instalar-mods.sh
│       └── 3-accesos-directos.sh
├── Modpack_Santi_Server/   ← archivos para el server (van al hosting de MC)
│   ├── mods/               ← (no usar, los mods los baja el cliente)
│   └── world/
└── mods.csv                ← CSV con filename,url (referencia)
```

## Para los amigos

1. Bajar `Servidor-Amiguos-Installer.zip` desde GitHub Releases
2. Descomprimir
3. Doble-click a `Windows\1-instalar-tlauncher.bat` (si no tenés TLauncher)
4. Doble-click a `Windows\2-instalar-mods.bat` (instala los 31 mods)
5. Abrir TLauncher, login con cualquier username
6. Crear perfil: 1.21.1 + Fabric 0.16.5
7. Conectarse a: `amiguos.holy.gg`

## Para actualizar mods

1. Modificar `mods/*.pw.toml` con nueva version (o agregar/quitar mods)
2. Regenerar `index.toml` con el script de PowerShell
3. Actualizar el hash en `pack.toml`
4. Commit + push al repo
5. Coolify hace auto-deploy
6. Tus amigos re-correrán `2-instalar-mods.bat` y obtendrán los nuevos mods
