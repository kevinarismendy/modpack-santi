# Seeds investigadas para SantiCraft

Investigación con Playwright en Reddit, YouTube, 9minecraft y seed maps. Mayo 2026.

## Recomendación principal

**Seed: `4815162342528827879`**

- **Spawn:** Planicie central continental, "shattered isles" (islas rotas con mucho terreno central)
- **Aldeas:** 2+ confirmadas en perímetro
- **Biomas Terralith:** 85+ biomas accesibles desde spawn
- **Estructuras:** Trial Chambers vanilla, mansión lejana, dungeons de When Dungeons Arise operativos
- **Por qué es buena para 10 amigos:** Cada jugador puede reclamar un bioma en dirección cardinal diferente sin chocarse — spawn "hub central" ideal para SMP
- **Fuentes:**
  - Reddit r/feedthebeast (1fj23vw)
  - Mapa de biomas dedicado: https://map.jacobsjo.eu/?mc_version=1_21_1&seed=4815162342528827879

## Backup

**Seed: `85425578410475571`**

- Mangrove Swamp + montaña + Cherry Grove (Terralith)
- 30+ comentarios en Reddit, video de YouTube con 82.7k views ("TOP 5 Terralith & Tectonic" — Minecraft Kingdom)
- Funciona idéntico en 1.21.1 (Terralith no cambió el worldgen entre 1.20 y 1.21)

## Alternativas

| Seed | Notas |
|------|-------|
| `138660467146790` | Seed #2 en TOP 5 de Minecraft Kingdom. Terralith + Tectonic. |
| `7215514390165603213` | Seed #13 en TOP 18 de 9minecraft. Multi-biomas Terralith. |
| `444420604380503` | Seed #1 en TOP 18 de 9minecraft. Perfil vanilla+. |

## server.properties

```
level-seed=4815162342528827879
level-type=minecraft:normal
generator-settings={}
```

`generator-settings={}` está bien — Terralith no usa overrides JSON en el server.properties, se instala como datapack en `world/datapacks/`.

## Verificación previa

Antes de generar el mundo definitivo:

1. Crear mundo singleplayer temporal con Terralith instalado
2. `/locate biome cherry_grove` desde spawn
3. Si en 30 segundos no hay resultado → probar `85425578410475571`
4. Si tampoco → random + filtrar en https://www.chunkbase.com/apps/seed-map

## Limitaciones

- Chunkbase y Reddit directo fueron bloqueados por anti-bot (challenge page)
- No se pudo verificar seeds en vivo con mcseedmap.net
- Las recomendaciones #3-5 están citadas en 1 fuente fuerte cada una (9minecraft o YouTube), usar como backup no como principal
