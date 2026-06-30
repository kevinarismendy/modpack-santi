#!/bin/bash
cd "$(dirname "$0")"

REPO="https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main"

echo "============================================"
echo "  Servidor Amiguos - Launcher"
echo "============================================"
echo ""

# --- Self-update: descargar la ultima version del launcher desde GitHub ---
echo "[1/3] Verificando actualizaciones del launcher..."
TEMP_LAUNCHER="/tmp/servidor_amigos_launcher_$$.sh"
if curl -L -sS -o "$TEMP_LAUNCHER" "$REPO/launcher.sh" 2>/dev/null && [ -s "$TEMP_LAUNCHER" ]; then
    if ! cmp -s "$0" "$TEMP_LAUNCHER"; then
        echo "      Launcher actualizado. Reiniciando..."
        cp "$TEMP_LAUNCHER" "$0"
        rm "$TEMP_LAUNCHER"
        bash "$0" "$@"
        exit $?
    else
        echo "      Launcher al dia."
    fi
    rm "$TEMP_LAUNCHER" 2>/dev/null
else
    echo "      [WARN] No se pudo verificar actualizaciones."
fi

# --- Descargar el instalador ---
echo "[2/3] Descargando instalador..."
TEMP_INSTALLER="/tmp/servidor_amigos_installer_$$.sh"
if ! curl -L -sS -o "$TEMP_INSTALLER" "$REPO/install.sh"; then
    echo "[ERROR] No se pudo descargar el instalador."
    echo "Verifica tu conexion a internet."
    exit 1
fi
chmod +x "$TEMP_INSTALLER"
bash "$TEMP_INSTALLER"
exit $?
