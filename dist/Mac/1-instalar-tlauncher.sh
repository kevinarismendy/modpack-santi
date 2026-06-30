#!/bin/bash
# 1-instalar-tlauncher.sh
echo "============================================"
echo "  [1/3] Instalador de TLauncher (Mac)"
echo "============================================"
echo ""

TLAUNCHER_DIR="$HOME/Library/Application Support/.tlauncher"
TLAUNCHER_APP="$TLAUNCHER_DIR/TLauncher.app"

if [ -d "$TLAUNCHER_APP" ]; then
    echo "[OK] TLauncher ya esta instalado: $TLAUNCHER_APP"
    echo ""
    read -p "Presiona ENTER para cerrar..."
    exit 0
fi

echo "[!] TLauncher no encontrado."
echo "Bajalo desde https://tlauncher.org/en/ y mueve TLauncher.app a:"
echo "  $TLAUNCHER_DIR/"
echo ""
echo "O instalalo en Applications/ con el .dmg"
echo ""
read -p "Cuando termines, presiona ENTER para re-detectar..."

if [ -d "/Applications/TLauncher.app" ]; then
    echo "[OK] TLauncher encontrado en /Applications/"
elif [ -d "$TLAUNCHER_APP" ]; then
    echo "[OK] TLauncher en $TLAUNCHER_APP"
else
    echo "[!] TLauncher no detectado. Volve a correr este script despues de instalarlo."
fi
echo ""
read -p "Presiona ENTER para cerrar..."
