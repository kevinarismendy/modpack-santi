# Regenera index.toml desde mods/*.pw.toml
# Uso: .\regen-index.ps1
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

$modsDir = Join-Path $repoRoot "mods"
$indexPath = Join-Path $repoRoot "index.toml"
$packPath = Join-Path $repoRoot "pack.toml"

if (-not (Test-Path $modsDir)) { Write-Error "No existe $modsDir"; exit 1 }

# Generar index.toml
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('hash-format = "sha256"')
$lines.Add("")
foreach ($f in Get-ChildItem "$modsDir\*.pw.toml" | Sort-Object Name) {
    $rel = "mods/" + $f.Name
    $hash = (Get-FileHash -Path $f.FullName -Algorithm SHA256).Hash.ToLower()
    $lines.Add("[[files]]")
    $lines.Add("file = ""$rel""")
    $lines.Add("hash = ""$hash""")
    $lines.Add("metafile = true")
    $lines.Add("")
}
[System.IO.File]::WriteAllText($indexPath, ($lines -join "`r`n"), $utf8NoBom)
Write-Host "index.toml: $((Get-ChildItem "$modsDir\*.pw.toml").Count) mods"

# Actualizar pack.toml con el hash del nuevo index
$indexHash = (Get-FileHash -Path $indexPath -Algorithm SHA256).Hash.ToLower()
$packContent = @(
    'name = "Servidor Amiguos"',
    'author = "Santiago"',
    'version = "1.0.0"',
    'pack-format = "packwiz:1.1.0"',
    "",
    "[index]",
    'file = "index.toml"',
    'hash-format = "sha256"',
    "hash = ""$indexHash""",
    "",
    "[versions]",
    'minecraft = "1.21.1"',
    'fabric = "0.16.5"',
    "",
    "[options]",
    'acceptable-game-versions = ["1.21.1"]',
    'clientside-mods = true',
    'serverside-mods = false'
) -join "`r`n"
[System.IO.File]::WriteAllText($packPath, $packContent, $utf8NoBom)
Write-Host "pack.toml: hash = $indexHash"

# Verificar BOM
$idxBytes = [System.IO.File]::ReadAllBytes($indexPath)
$packBytes = [System.IO.File]::ReadAllBytes($packPath)
$idxBom = $idxBytes.Length -ge 3 -and $idxBytes[0] -eq 0xEF -and $idxBytes[1] -eq 0xBB -and $idxBytes[2] -eq 0xBF
$packBom = $packBytes.Length -ge 3 -and $packBytes[0] -eq 0xEF -and $packBytes[1] -eq 0xBB -and $packBytes[2] -eq 0xBF
Write-Host "BOM check: index=$idxBom, pack=$packBom"
