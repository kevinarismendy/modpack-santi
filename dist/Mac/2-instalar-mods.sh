#!/bin/bash
# 2-instalar-mods.sh (Mac)
# Detecta TLauncher + Java, baja packwiz bootstrap desde GitHub raw,
# descarga los 34 mods Fabric y los copia a la carpeta de mods de TLauncher.

set -e
cd "$(dirname "$0")"

BASE_URL="https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main"
BOOTSTRAP_JAR="packwiz-installer-bootstrap.jar"
CACHE_BUST="$RANDOM$RANDOM"
BOOTSTRAP_URL="${BASE_URL}/pack.toml?cb=${CACHE_BUST}"
BOOTSTRAP_JAR_URL="${BASE_URL}/${BOOTSTRAP_JAR}?cb=${CACHE_BUST}"
INSTANCE="Servidor Amiguos"
SERVER_IP="135.148.137.58:19403"

echo "============================================"
echo "  [2/3] Instalador de Mods (Mac)"
echo "  MC 1.21.1 + Fabric 0.19.3"
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
    echo "[ERROR] TLauncher no esta instalado."
    echo "Primero corre \"1-instalar-tlauncher.sh\""
    read -p "ENTER para cerrar..."
    exit 1
fi
echo "[OK] TLauncher: $TLAUNCHER_APP"
echo ""

# --- Detectar Java 21+ ---
echo "Detectando Java..."
JAVA_CMD=""
if command -v java &>/dev/null; then
    JAVA_VERSION_RAW=$(java -version 2>&1 | head -1)
    JAVA_MAJOR=$(echo "$JAVA_VERSION_RAW" | awk -F'"' '{print $2}' | awk -F. '{print $1}')
    if [ -n "$JAVA_MAJOR" ] && [ "$JAVA_MAJOR" -ge 21 ] 2>/dev/null; then
        JAVA_CMD="java"
        echo "[OK] Java $JAVA_MAJOR detectado"
    else
        echo "[!] Java encontrado pero version < 21: $JAVA_VERSION_RAW"
    fi
fi

if [ -z "$JAVA_CMD" ]; then
    echo "[!] Java 21+ no encontrado o version incorrecta."
    echo "Instala con: brew install openjdk@21"
    read -p "ENTER para cerrar..."
    exit 1
fi
echo ""

# --- Verificar conexion a GitHub ---
echo "Verificando conexion a GitHub..."
if ! curl -L -sS -o /dev/null -w "" "$BOOTSTRAP_URL" --max-time 10; then
    echo "[ERROR] No se puede conectar a GitHub."
    echo "Verifica tu conexion a internet."
    read -p "ENTER para cerrar..."
    exit 1
fi
echo "[OK] GitHub accesible"
echo ""

# --- Descargar packwiz-installer-bootstrap.jar ---
if [ ! -f "$BOOTSTRAP_JAR" ]; then
    echo "Descargando packwiz bootstrap..."
    if ! curl -L -sS -o "$BOOTSTRAP_JAR" "$BOOTSTRAP_JAR_URL" --max-time 60; then
        echo "[ERROR] No se pudo descargar el bootstrap."
        read -p "ENTER para cerrar..."
        exit 1
    fi
fi
echo "[OK] Bootstrap listo"
echo ""

# --- Limpiar cache viejo del bootstrap ---
rm -f "$TMPDIR/pack.toml" 2>/dev/null
rm -rf "$TMPDIR/pw_zip" 2>/dev/null
rm -rf "$TMPDIR/pw_test" 2>/dev/null

# --- Bajar mods via packwiz-installer ---
echo "Descargando 34 mods Fabric desde GitHub (cache-bust)..."
TEMP_DIR="$TMPDIR/santicraft-mods-$$"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"
"$JAVA_CMD" -jar "$(cd .. && pwd)/$BOOTSTRAP_JAR" -g "$BOOTSTRAP_URL"
BOOTSTRAP_RC=$?
cd - >/dev/null

if [ $BOOTSTRAP_RC -ne 0 ]; then
    echo "[ERROR] Fallo la descarga de mods (codigo: $BOOTSTRAP_RC)."
    rm -rf "$TEMP_DIR"
    read -p "ENTER para cerrar..."
    exit 1
fi

# packwiz-installer guarda mods en ./mods/ o ./minecraft/mods/
MODS_SOURCE=""
if [ -d "$TEMP_DIR/mods" ]; then
    MODS_SOURCE="$TEMP_DIR/mods"
elif [ -d "$TEMP_DIR/minecraft/mods" ]; then
    MODS_SOURCE="$TEMP_DIR/minecraft/mods"
fi

if [ -z "$MODS_SOURCE" ]; then
    echo "[ERROR] No se encontraron mods descargados."
    rm -rf "$TEMP_DIR"
    read -p "ENTER para cerrar..."
    exit 1
fi

# --- Destino: instancia aislada versions/Servidor Amiguos/mods ---
MC_DIR="$HOME/Library/Application Support/.minecraft"
INSTANCE_DIR="$MC_DIR/versions/$INSTANCE"
MODS_DEST="$INSTANCE_DIR/mods"
mkdir -p "$MODS_DEST"
echo ""
echo "Instancia: $INSTANCE_DIR"
echo ""

# --- Copiar mods ---
echo "Copiando mods..."
cp -r "$MODS_SOURCE/"* "$MODS_DEST/"
rm -rf "$TEMP_DIR"
MOD_COUNT=$(ls -1 "$MODS_DEST"/*.jar 2>/dev/null | wc -l | tr -d ' ')
echo "[OK] $MOD_COUNT mods instalados en la instancia \"$INSTANCE\""
echo ""

# --- Escribir servers.dat (NBT sin comprimir) con el server preconfigurado ---
echo "Configurando servidor $SERVER_IP ..."
if [ -f "$INSTANCE_DIR/servers.dat" ]; then
    echo "[OK] servers.dat ya existe, no se sobrescribe."
else
    write_len() { printf "\\x$(printf %02x $(( $1 >> 8 )))\\x$(printf %02x $(( $1 & 255 )))"; }
    {
        printf '\x0a\x00\x00\x09\x00\x07servers\x0a\x00\x00\x00\x01'
        printf '\x08\x00\x02ip'; write_len ${#SERVER_IP}; printf '%s' "$SERVER_IP"
        printf '\x08\x00\x04name'; write_len ${#INSTANCE}; printf '%s' "$INSTANCE"
        printf '\x01\x00\x06hidden\x00'
        printf '\x00\x00'
    } > "$INSTANCE_DIR/servers.dat"
    if [ -f "$INSTANCE_DIR/servers.dat" ]; then
        echo "[OK] Servidor agregado: $SERVER_IP"
    else
        echo "[!] No se pudo escribir servers.dat. Agrega el server manualmente."
    fi
fi
echo ""

echo "============================================"
echo "  Listo. Ya podes jugar."
echo ""
echo "  Los mods se copiaron a: $MODS_DEST"
echo ""
echo "  1) Abre TLauncher"
echo "  2) Login con cualquier username (no-premium)"
echo "  3) Crea/selecciona una version Fabric 1.21.1 (Loader 0.19.3+)"
echo "     y nombrala EXACTAMENTE:  $INSTANCE"
echo "     (con 'carpetas separadas por version' activado)"
echo "  4) El servidor $SERVER_IP ya aparece en la lista"
echo "============================================"
echo ""
read -p "ENTER para cerrar..."
