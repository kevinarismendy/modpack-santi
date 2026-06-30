# SantiCraft

Modpack privado de Minecraft 1.21.1 + NeoForge 21.1.234 para 10 amigos.

## Stack

- **MC version:** 1.21.1
- **Mod loader:** NeoForge 21.1.234
- **Server:** HolyHosting (16GB RAM, 2 cores Ryzen) — `amiguos.holy.gg`
- **Domain:** amiguos.holy.gg
- **Distribución:** PrismLauncher (offline) + packwiz-installer bootstrap desde este repo
- **Actualización:** automática al hacer push a `main` (los clientes bajan los mods al abrir MC)

## Instalación para jugadores

Ver `dist/README.txt` (incluido en la distribución del modpack).

## Server

- `server.properties`: `online-mode=false`, `max-players=15`
- Seed recomendada: `4815162342528827879` (ver `docs/seeds.md`)
- 39 mods (28 client + 5 dependencias + 5 server-only)
- Java 21 requerido

## Para el admin (desarrollo del modpack)

```bash
# Agregar mod de Modrinth
packwiz modrinth install --yes <slug>

# Agregar mod de CurseForge
packwiz curseforge install --yes <slug>

# Refresh después de cambios manuales
packwiz refresh

# Exportar .mrpack para distribución
packwiz modrinth export -o dist/SantiCraft-1.0.0.mrpack

# Servir localmente para testing
packwiz serve
```

URL raw del pack (para bootstrap):
```
https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main/pack.toml
```

## Skins

No hay mod server-side compatible con NeoForge 1.21.1 (SkinsRestorer requiere 1.21.11+). El modpack usa **CustomSkinLoader** (client-side). Cada amigo debe poner su skin `.png` en `<instancia>/.minecraft/CustomSkinLoader/local/skins/<username>.png`.

Para pre-cargar skins default por jugador, el admin puede agregar archivos a `overrides/CustomSkinLoader/local/skins/` antes de exportar el .mrpack.

## Estructura

```
.
├── pack.toml                 # metadata principal (name, version, mc, loader)
├── index.toml                # índice de mods con hashes SHA256
├── mods/                     # un .pw.toml por mod
│   ├── embeddium.pw.toml
│   ├── terralith.pw.toml
│   └── ...
├── .gitignore                # excluye packwiz.exe y dist/
└── docs/
    └── seeds.md              # análisis de seeds
```
