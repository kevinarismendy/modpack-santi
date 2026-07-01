# Servidor Amiguos - Modpack Installer

Modpack de Minecraft **1.21.1 + Fabric 0.19.3** para ~10 amigos.

## Como funciona

- El repo se sirve desde **GitHub raw** (con cache-bust `?cb=random`).
- El cliente (TLauncher + Fabric) baja los mods con **packwiz** directo desde GitHub.
- El servidor de Minecraft (`135.148.137.58:19403`, HolyHosting) corre Fabric con los mismos 34 mods.
- Los mods se instalan en una **instancia aislada** de TLauncher: `.minecraft/versions/Servidor Amiguos/mods/`.

> No hay VPS. El intento con Coolify/servermc se descartó.

## Estructura de archivos

```
/
├── pack.toml                 ← entry point del modpack (mc 1.21.1, fabric 0.19.3)
├── index.toml                ← lista de mods (regenerable)
├── packwiz-installer-bootstrap.jar
├── regen-index.ps1           ← regenera index.toml
├── mods/                     ← 34 .pw.toml (metadata packwiz)
│   ├── accessories.pw.toml
│   └── ...
├── mods.csv                  ← referencia filename,url (NO lo usa el cliente)
└── dist/                     ← scripts del cliente (Windows + Mac)
    ├── Windows/
    │   ├── 1-instalar-tlauncher.bat
    │   ├── 2-instalar-mods.bat
    │   └── 3-accesos-directos.bat
    └── Mac/
        ├── 1-instalar-tlauncher.sh
        ├── 2-instalar-mods.sh
        └── 3-accesos-directos.sh
```

## Para los amigos

1. Bajar `Servidor-Amiguos-Installer.zip` desde GitHub Releases y descomprimir.
2. `1-instalar-tlauncher` (si no tenés TLauncher).
3. En TLauncher: crear una versión **Fabric 1.21.1 (Loader 0.19.3+)** y nombrarla
   **exactamente `Servidor Amiguos`**, con "carpetas separadas por versión" activado.
4. `2-instalar-mods` → baja los 34 mods a `versions/Servidor Amiguos/mods/` y
   preconfigura el servidor `135.148.137.58:19403`.
5. `3-accesos-directos` → crea accesos directos en el escritorio.
6. Abrir TLauncher, login con cualquier username, seleccionar `Servidor Amiguos` y jugar.

## Para actualizar mods

1. Modificar `mods/*.pw.toml` (nueva versión, o agregar/quitar mods).
2. Regenerar el índice: `.\regen-index.ps1` (actualiza `index.toml` y su hash en `pack.toml`).
3. Commit + push al repo.
4. Los amigos re-corren `2-instalar-mods` (o el acceso directo "Actualizar").
