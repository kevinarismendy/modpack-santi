#!/bin/bash
cd "$(dirname "$0")"
REPO="https://cdn.jsdelivr.net/gh/kevinarismendy/modpack-santi@main"
SCRIPT="/tmp/santicraft_$$.sh"

echo "============================================"
echo "  Servidor Amiguos - Launcher"
echo "  Bajando codigo desde GitHub..."
echo "============================================"
echo ""

curl -L -sS -o "$SCRIPT" "$REPO/install.sh" || { echo "[ERROR] No se pudo conectar a GitHub."; exit 1; }
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
