#!/bin/bash
cd "$(dirname "$0")"

LAUNCHER_VERSION="1.5.2"
REPO="https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main"

echo "============================================"
echo "  Servidor Amiguos - Launcher v$LAUNCHER_VERSION"
echo "============================================"
echo ""

# --- [1/3] Self-update (skip if already updated this session) ---
if [ "$1" = "skip" ]; then
    echo "[1/3] Launcher v$LAUNCHER_VERSION cargado. Continuando..."
else
    echo "[1/3] Verificando actualizaciones del launcher..."
    TEMP_VERSION="/tmp/santicraft_version_$$.txt"
    REMOTE_VERSION=""
    if curl -L -sS -o "$TEMP_VERSION" "$REPO/version.txt" 2>/dev/null && [ -s "$TEMP_VERSION" ]; then
        REMOTE_VERSION=$(cat "$TEMP_VERSION" | tr -d '[:space:]')
        rm "$TEMP_VERSION"
    fi
    if [ -n "$REMOTE_VERSION" ]; then
        if [ "$REMOTE_VERSION" != "$LAUNCHER_VERSION" ]; then
            echo "      Local: v$LAUNCHER_VERSION | Remota: v$REMOTE_VERSION"
            echo "      Actualizando launcher..."
            TEMP_NEW="/tmp/santicraft_launcher_$$.sh"
            if curl -L -sS -o "$TEMP_NEW" "$REPO/launcher.sh" 2>/dev/null && [ -s "$TEMP_NEW" ]; then
                cp "$TEMP_NEW" "$0"
                rm "$TEMP_NEW"
                echo "      Reiniciando con la nueva version..."
                bash "$0" skip
                exit 0
            else
                echo "      [WARN] No se pudo descargar el nuevo launcher."
            fi
        else
            echo "      Launcher al dia (v$LAUNCHER_VERSION)."
        fi
    else
        echo "      [WARN] No se pudo leer la version remota. Continuando con v$LAUNCHER_VERSION."
    fi
fi

# --- [2/3] Descargar y ejecutar instalador ---
echo "[2/3] Descargando instalador..."
TEMP_INSTALLER="/tmp/santicraft_installer_$$.sh"
if ! curl -L -sS -o "$TEMP_INSTALLER" "$REPO/install.sh"; then
    echo ""
    echo "[ERROR] No se pudo descargar el instalador."
    echo "Descargalo manualmente desde:"
    echo "  https://github.com/kevinarismendy/modpack-santi/releases/latest"
    exit 1
fi
chmod +x "$TEMP_INSTALLER"

echo "[3/3] Ejecutando instalador..."
echo ""
bash "$TEMP_INSTALLER"
RC=$?
rm "$TEMP_INSTALLER"

echo ""
echo "============================================"
if [ $RC -ne 0 ]; then
    echo "  El instalador termino con errores."
    echo "  Revisa los mensajes arriba."
else
    echo "  Todo listo. Tu acceso directo a PrismLauncher esta en el escritorio."
fi
echo "============================================"
echo ""
echo "============================================"
echo "   >>>>>>  Presiona ENTER para cerrar  <<<<<<"
echo "============================================"
read -r _
exit $RC
