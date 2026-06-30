# Regenera index.toml y pack.toml desde mods/*.pw.toml
# Hash se calcula con clean filter (LF puro) para que matchee con Git y VPS

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

$modsDir = Join-Path $repoRoot "mods"
$indexPath = Join-Path $repoRoot "index.toml"
$packPath = Join-Path $repoRoot "pack.toml"

if (-not (Test-Path $modsDir)) { Write-Error "No existe $modsDir"; exit 1 }

function Get-CleanHash($filePath) {
    $bytes = [System.IO.File]::ReadAllBytes($filePath)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    $text = $text -replace "`r`n", "`n"
    $cleanBytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($cleanBytes)
    return -join ($hash | ForEach-Object { $_.ToString("x2") })
}

$modHashes = @{}
foreach ($f in Get-ChildItem "$modsDir\*.pw.toml" | Sort-Object Name) {
    $rel = "mods/" + $f.Name
    $hash = Get-CleanHash $f.FullName
    $modHashes[$rel] = $hash
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('hash-format = "sha256"')
foreach ($rel in ($modHashes.Keys | Sort-Object)) {
    $lines.Add("[[files]]")
    $lines.Add("file = ""$rel""")
    $lines.Add("hash = ""$($modHashes[$rel])""")
    $lines.Add("metafile = true")
}
$content = ($lines -join "`n") + "`n"
[System.IO.File]::WriteAllText($indexPath, $content, $utf8NoBom)

$indexHash = Get-CleanHash $indexPath

$packLines = @(
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
)
$packContent = ($packLines -join "`n") + "`n"
[System.IO.File]::WriteAllText($packPath, $packContent, $utf8NoBom)

Write-Host "index.toml: $($modHashes.Count) mods"
Write-Host "  clean hash: $indexHash"
Write-Host "pack.toml:"
Write-Host "  apunta a:   $indexHash"
