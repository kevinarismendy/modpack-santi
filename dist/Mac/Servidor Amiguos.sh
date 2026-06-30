#!/bin/bash
cd "$(dirname "$0")"
SCRIPT_URL="https://github.com/kevinarismendy/modpack-santi/releases/latest/download/install.sh"
SCRIPT="/tmp/santicraft_$$.sh"

echo "============================================"
echo "  Servidor Amiguos - Launcher"
echo "  Bajando codigo desde GitHub..."
echo "============================================"
echo ""

curl -L -sS -o "$SCRIPT" "$SCRIPT_URL" || { echo "[ERROR] No se pudo conectar a GitHub."; exit 1; }
chmod +x "$SCRIPT"

bash "$SCRIPT"
RC=$?
rm "$SCRIPT"

echo ""
echo "============================================"
echo "  Presiona ENTER para cerrar"
echo "============================================"
read -r _
exit $RC
