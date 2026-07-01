#!/bin/bash
# 1-instalar-tlauncher.sh (Mac)

echo "============================================"
echo "  [1/3] Instalador de TLauncher (Mac)"
echo "============================================"
echo ""

TLAUNCHER_APP=""
TLAUNCHER_DIR=""

# Buscar TLauncher en ubicaciones comunes
for APP in \
    "/Applications/TLauncher.app" \
    "$HOME/Applications/TLauncher.app" \
    "$HOME/Library/Application Support/.tlauncher/TLauncher.app" \
    "$HOME/Library/Application Support/.minecraft/TLauncher.app"; do
    if [ -d "$APP" ]; then
        TLAUNCHER_APP="$APP"
        TLAUNCHER_DIR="$(dirname "$APP")"
        break
    fi
done

if [ -n "$TLAUNCHER_APP" ]; then
    echo "[OK] TLauncher ya esta instalado: $TLAUNCHER_APP"
    echo ""
    read -p "Presiona ENTER para cerrar..."
    exit 0
fi

echo "[!] TLauncher no encontrado."
echo ""
echo "Opciones para instalar TLauncher:"
echo ""
echo "1) Descarga TLauncher desde: https://tlauncher.org/en/"
echo "2) Mueve TLauncher.app a /Applications/ o ~/Applications/"
echo "3) Vuelve a correr este script"
echo ""
read -p "Cuando termines, presiona ENTER para re-detectar..."

# Re-detectar
for APP in \
    "/Applications/TLauncher.app" \
    "$HOME/Applications/TLauncher.app" \
    "$HOME/Library/Application Support/.tlauncher/TLauncher.app" \
    "$HOME/Library/Application Support/.minecraft/TLauncher.app"; do
    if [ -d "$APP" ]; then
        TLAUNCHER_APP="$APP"
        TLAUNCHER_DIR="$(dirname "$APP")"
        break
    fi
done

if [ -n "$TLAUNCHER_APP" ]; then
    echo "[OK] TLauncher detectado: $TLAUNCHER_APP"
else
    echo "[!] TLauncher sigue sin detectar. Instala y vuelve a correr."
fi
echo ""
read -p "ENTER para cerrar..."
