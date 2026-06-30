#!/bin/bash
set -e
SCRIPT_URL="https://github.com/kevinarismendy/modpack-santi/releases/latest/download/install.sh"
BOOTSTRAP_URL="https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
WORKDIR="$HOME/.servidor-amiguos-tmp"

mkdir -p "$WORKDIR"
echo "[1/4] Bajando instalador..."
curl -L -sS -o "$WORKDIR/install.sh" "$SCRIPT_URL"
chmod +x "$WORKDIR/install.sh"

echo "[2/4] Bajando packwiz bootstrap..."
curl -L -sS -o "$WORKDIR/packwiz-installer-bootstrap.jar" "$BOOTSTRAP_URL"

echo "[3/4] Ejecutando instalador..."
cd "$WORKDIR"
bash "$WORKDIR/install.sh"

echo "[4/4] Limpiando temporales..."
rm -rf "$WORKDIR"

echo ""
echo "Listo. Ya podes abrir TLauncher y jugar."
echo ""
read -p "Presiona ENTER para cerrar..."
