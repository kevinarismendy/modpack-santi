#!/bin/bash
# 2-instalar-mods.sh
set -e
cd "$(dirname "$0")"

echo "============================================"
echo "  [2/3] Instalador de Mods (Mac)"
echo "  MC 1.21.1 + Fabric 0.16.5"
echo "============================================"
echo ""

BOOTSTRAP_URL="https://cdn.jsdelivr.net/gh/kevinarismendy/modpack-santi@main/pack.toml"
BOOTSTRAP_JAR="packwiz-installer-bootstrap.jar"
MODS_DEST="$HOME/Library/Application Support/.minecraft/mods"
TEMP_DIR="$TMPDIR/santicraft-mods-$$"

# Verificar Java
JAVA_CMD=""
if command -v java &>/dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -1 | awk -F'"' '{print $2}' | awk -F. '{ if ($1+0 >= 21) print $1 }')
    if [ -n "$JAVA_VERSION" ]; then
        JAVA_CMD="java"
        echo "[OK] Java $JAVA_VERSION detectado"
    fi
fi

if [ -z "$JAVA_CMD" ]; then
    echo "[!] Java 21+ no encontrado."
    echo "Instala Java 21 con: brew install openjdk@21"
    read -p "ENTER para cerrar..."
    exit 1
fi
echo ""

# Bootstrap
if [ ! -f "$BOOTSTRAP_JAR" ]; then
    echo "Descargando packwiz bootstrap..."
    curl -L -sS -o "$BOOTSTRAP_JAR" "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
fi
echo "[OK] Bootstrap listo"
echo ""

# Bajar mods
echo "Descargando 39 mods..."
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"
java -jar "$(dirname "$0")/$BOOTSTRAP_JAR" -g "$BOOTSTRAP_URL"
cd - >/dev/null

if [ ! -d "$TEMP_DIR/minecraft/mods" ]; then
    echo "[ERROR] No se descargaron mods"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Copiar mods
mkdir -p "$MODS_DEST"
echo "Copiando mods a $MODS_DEST ..."
cp -r "$TEMP_DIR/minecraft/mods/"* "$MODS_DEST/"
rm -rf "$TEMP_DIR"
echo "[OK] 39 mods instalados"
echo ""

echo "============================================"
echo "  Mods listos. Abre TLauncher, crea perfil:"
echo "    Version: 1.21.1"
echo "    Loader: Fabric"
echo "    Loader version: 0.16.5"
echo "  Y conectate a: amiguos.holy.gg"
echo "============================================"
echo ""
read -p "ENTER para cerrar..."
