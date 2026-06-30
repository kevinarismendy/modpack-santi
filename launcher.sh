#!/bin/bash
cd "$(dirname "$0")"

echo "============================================"
echo "  Servidor Amiguos - Launcher"
echo "============================================"
echo ""
echo "Descargando ultima version del instalador..."

INSTALL_SCRIPT="/tmp/servidor_amigos_install.sh"
curl -L -sS -o "$INSTALL_SCRIPT" "https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main/install.sh"
if [ $? -ne 0 ]; then
    echo "[ERROR] No se pudo descargar el instalador."
    echo "Verifica tu conexion a internet."
    exit 1
fi
chmod +x "$INSTALL_SCRIPT"
bash "$INSTALL_SCRIPT"
exit $?
