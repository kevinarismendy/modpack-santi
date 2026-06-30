#!/bin/bash
# 3-accesos-directos.sh (Mac)
echo "============================================"
echo "  [3/3] Creador de Accesos Directos (Mac)"
echo "============================================"
echo ""

# En Mac los "accesos directos" son aliases en el Dock
TLAUNCHER_APP="/Applications/TLauncher.app"
[ ! -d "$TLAUNCHER_APP" ] && TLAUNCHER_APP="$HOME/Library/Application Support/.tlauncher/TLauncher.app"

if [ ! -d "$TLAUNCHER_APP" ]; then
    echo "[ERROR] TLauncher no encontrado"
    read -p "ENTER para cerrar..."
    exit 1
fi

DESKTOP="$HOME/Desktop"

# Crear accesos directos en escritorio (Mac usa .command files que se ejecutan con doble click)
cat > "$DESKTOP/Servidor Amiguos - TLauncher.command" <<EOF
#!/bin/bash
open "$TLAUNCHER_APP"
EOF

cat > "$DESKTOP/Servidor Amiguos - Actualizar.command" <<EOF
#!/bin/bash
cd "$(dirname "$0")"
bash "$(dirname "$0")/2-instalar-mods.sh"
EOF

chmod +x "$DESKTOP/Servidor Amiguos - TLauncher.command"
chmod +x "$DESKTOP/Servidor Amiguos - Actualizar.command"

echo "[OK] Accesos directos creados en el escritorio:"
echo "  - Servidor Amiguos - TLauncher.command"
echo "  - Servidor Amiguos - Actualizar.command"
echo ""
read -p "ENTER para cerrar..."
