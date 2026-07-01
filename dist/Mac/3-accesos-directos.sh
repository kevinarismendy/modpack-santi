#!/bin/bash
# 3-accesos-directos.sh (Mac)
# Crea .command files en el escritorio para TLauncher y para actualizar mods.
# Los .command files se ejecutan con doble click (abren Terminal).

echo "============================================"
echo "  [3/3] Creador de Accesos Directos (Mac)"
echo "============================================"
echo ""

# --- Detectar TLauncher ---
TLAUNCHER_APP=""
for APP in \
    "/Applications/TLauncher.app" \
    "$HOME/Applications/TLauncher.app" \
    "$HOME/Library/Application Support/.tlauncher/TLauncher.app" \
    "$HOME/Library/Application Support/.minecraft/TLauncher.app"; do
    if [ -d "$APP" ]; then
        TLAUNCHER_APP="$APP"
        break
    fi
done

if [ -z "$TLAUNCHER_APP" ]; then
    echo "[ERROR] TLauncher no encontrado."
    echo "Primero corre \"1-instalar-tlauncher.sh\""
    read -p "ENTER para cerrar..."
    exit 1
fi

# --- Determinar rutas ---
# Ruta absoluta del directorio donde esta este script (la carpeta Mac/)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DESKTOP="$HOME/Desktop"

echo "TLauncher: $TLAUNCHER_APP"
echo "Script dir: $SCRIPT_DIR"
echo "Creando accesos directos en el escritorio..."
echo ""

# --- Crear acceso directo a TLauncher ---
cat > "$DESKTOP/Servidor Amiguos - TLauncher.command" <<EOF
#!/bin/bash
open "$TLAUNCHER_APP"
EOF

# --- Crear acceso directo para actualizar mods ---
# Usa la ruta absoluta de la carpeta Mac donde esta 2-instalar-mods.sh
cat > "$DESKTOP/Servidor Amiguos - Actualizar.command" <<EOF
#!/bin/bash
bash "$SCRIPT_DIR/2-instalar-mods.sh"
EOF

# --- Hacer ejecutables ---
chmod +x "$DESKTOP/Servidor Amiguos - TLauncher.command"
chmod +x "$DESKTOP/Servidor Amiguos - Actualizar.command"

if [ -f "$DESKTOP/Servidor Amiguos - TLauncher.command" ] && [ -f "$DESKTOP/Servidor Amiguos - Actualizar.command" ]; then
    echo "[OK] Accesos directos creados en el escritorio:"
    echo "  - Servidor Amiguos - TLauncher.command"
    echo "  - Servidor Amiguos - Actualizar.command"
else
    echo "[ERROR] No se pudieron crear los accesos directos."
fi
echo ""
read -p "ENTER para cerrar..."
