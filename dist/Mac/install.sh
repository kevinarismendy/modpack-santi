#!/bin/bash
cd "$(dirname "$0")"

MIN_JAVA=21
JDK_DIR="$HOME/.jdk21"
EXTRACT_DIR="/tmp/jdk_extract_temp"
BOOTSTRAP_URL="https://cdn.jsdelivr.net/gh/kevinarismendy/modpack-santi@main/pack.toml"
LAUNCHER_URL="https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main/dist/launcher.sh"
TLAUNCHER_URL="https://github.com/kevinarismendy/modpack-santi/releases/download/tlauncher-v1/TLauncher.v17.zip"
BOOTSTRAP_JAR="packwiz-installer-bootstrap.jar"
SERVER="amiguos.holy.gg"

echo "============================================"
echo "  Servidor Amiguos - Modpack Installer"
echo "  MC 1.21.1 + Fabric 0.16.5"
echo "============================================"
echo ""

# --- [Pre] Auto-actualizar el launcher para la proxima corrida ---
echo "[Pre] Verificando actualizaciones del launcher..."
TEMP_LAUNCHER="/tmp/santicraft_launcher_$$.sh"
if curl -L -sS -o "$TEMP_LAUNCHER" "$LAUNCHER_URL" 2>/dev/null && [ -s "$TEMP_LAUNCHER" ]; then
    if ! cmp -s "$0" "$TEMP_LAUNCHER"; then
        echo "      Launcher actualizado. (proxima corrida usara la nueva version)"
        cp "$TEMP_LAUNCHER" "$0"
    else
        echo "      Launcher al dia."
    fi
    rm "$TEMP_LAUNCHER" 2>/dev/null
else
    echo "      [WARN] No se pudo verificar actualizaciones."
fi
echo ""

# --- Java 21 portable (auto-descarga desde Adoptium) ---
if ! command -v java &> /dev/null || [ "$(java -version 2>&1 | head -1 | sed -E 's/.*"([0-9]+)\.([0-9]+)\..*/\1/')" -lt "$MIN_JAVA" ] 2>/dev/null; then
    echo "[1/4] Java $MIN_JAVA+ no encontrado. Instalando portable desde Adoptium..."
    install_jdk_unix
    JAVA_CMD="$JDK_DIR/bin/java"
    if [ ! -x "$JAVA_CMD" ]; then
        echo "[ERROR] No se pudo instalar Java. Descargalo manualmente desde https://adoptium.net/"
        exit 1
    fi
else
    echo "[1/4] [OK] Java $MIN_JAVA+ detectado"
    JAVA_CMD="java"
fi

# --- TLauncher (auto-descarga) ---
echo "[2/4] Verificando TLauncher..."
TLAUNCHER_DIR="$HOME/.local/share/TLauncher"
if [ "$(uname)" = "Darwin" ]; then
    TLAUNCHER_DIR="$HOME/Library/Application Support/TLauncher"
fi
TLAUNCHER_BIN="$TLAUNCHER_DIR/tlauncher"
if [ -f "$TLAUNCHER_BIN" ] || [ -f "$TLAUNCHER_BIN.exe" ]; then
    echo "      [OK] TLauncher ya instalado en $TLAUNCHER_DIR"
else
    echo "      Descargando TLauncher (~26 MB)..."
    mkdir -p "$TLAUNCHER_DIR"
    TLAUNCHER_ZIP="/tmp/tlauncher.zip"
if [ "$(uname)" = "Darwin" ]; then
    echo "      Bajando TLauncher para Mac (~26 MB)..."
        curl -L -sS -o "$TLAUNCHER_ZIP" "https://github.com/kevinarismendy/modpack-santi/releases/download/tlauncher-v1/TLauncher.v17.zip" --max-time 180
    else
        curl -L -sS -o "$TLAUNCHER_ZIP" "https://github.com/kevinarismendy/modpack-santi/releases/download/tlauncher-v1/TLauncher.v17.zip" --max-time 180
    fi
    if [ -s "$TLAUNCHER_ZIP" ]; then
        unzip -q -o "$TLAUNCHER_ZIP" -d "$TLAUNCHER_DIR"
        chmod +x "$TLAUNCHER_DIR/tlauncher" 2>/dev/null
        rm "$TLAUNCHER_ZIP"
        echo "      [OK] TLauncher instalado en $TLAUNCHER_DIR"
    else
        echo "      [WARN] Descarga fallo. Baja TLauncher desde:"
        echo "      https://tlauncher.org/en/"
    fi
fi

# --- Bootstrap jar ---
if [ ! -f "$BOOTSTRAP_JAR" ]; then
    echo "[3/4] Descargando bootstrap..."
    curl -L -sS -o "$BOOTSTRAP_JAR" "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
fi

# --- Crear instancia de TLauncher automaticamente ---
echo "[4/4] Creando instancia 'Servidor Amiguos'..."
if [ -d "$TLAUNCHER_DIR/instances" ] && [ ! -d "$TLAUNCHER_DIR/instances/Servidor Amiguos" ]; then
    INSTANCE="$TLAUNCHER_DIR/instances/Servidor Amiguos"
    MODS_TEMP="/tmp/santicraft-mods"
    echo "      Bajando mods (49) a $MODS_TEMP..."
    mkdir -p "$MODS_TEMP"
    (cd "$MODS_TEMP" && $JAVA_CMD -jar "$BOOTSTRAP_JAR" -g "$BOOTSTRAP_URL")
    if [ -d "$MODS_TEMP/minecraft/mods" ]; then
        mkdir -p "$INSTANCE/.minecraft/mods"
        cp -r "$MODS_TEMP/minecraft/mods/"* "$INSTANCE/.minecraft/mods/"
        cp "$BOOTSTRAP_JAR" "$INSTANCE/.minecraft/packwiz-installer-bootstrap.jar"
        cat > "$INSTANCE/instance.cfg" <<'EOF'
InstanceType=OneSix
name=Servidor Amiguos
iconKey=grass_block
EOF
        echo "      [OK] Instancia creada"
    else
        echo "      [WARN] No se pudieron bajar los mods. Crea la instancia manual."
    fi
else
    if [ -d "$TLAUNCHER_DIR/instances/Servidor Amiguos" ]; then
        echo "      Instancia ya existe."
    fi
fi

# --- Instalar mods (solo si no hay instancia de TLauncher) ---
if [ ! -d "$TLAUNCHER_DIR/instances/Servidor Amiguos" ]; then
    echo "      Instalando mods en .minecraft/ default..."
    $JAVA_CMD -jar "$BOOTSTRAP_JAR" -g "$BOOTSTRAP_URL"
fi
echo ""
echo "============================================"
if [ "$(uname)" = "Darwin" ]; then
    echo "  1) Abre TLauncher: ~/Library/Application Support/TLauncher/tlauncher"
else
    echo "  1) Abre TLauncher: $HOME/.local/share/TLauncher/tlauncher"
fi
echo "  2) Login con cualquier username (sin password)"
echo "  3) Crea instancia 1.21.1 + Fabric 0.16.5"
echo "  4) Conectate a: $SERVER"
echo "============================================"
echo ""
echo "  Los mods y Java ya estan listos."
echo ""
echo "  Para buscar updates: vuelve a correr launcher.sh."
echo ""

# ========== Instalador portable de JDK 21 ==========
install_jdk_unix() {
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64) ARCH="x64" ;;
        aarch64|arm64) ARCH="aarch64" ;;
    esac

    JDK_URL="https://api.adoptium.net/v3/binary/latest/21/ga/${OS}/${ARCH}/jdk/hotspot/normal/eclipse"

    if [ "$OS" = "darwin" ]; then
        JDK_FILE="/tmp/santicraft_jdk.tar.gz"
    else
        JDK_FILE="/tmp/santicraft_jdk.tar.gz"
    fi

    echo "Descargando JDK 21 (portable, $OS/$ARCH) desde Adoptium..."
    curl -L -sS -o "$JDK_FILE" "$JDK_URL"
    if [ $? -ne 0 ]; then
        echo "[ERROR] No se pudo descargar JDK."
        return 1
    fi
    echo "Extrayendo JDK a $JDK_DIR ..."
    rm -rf "$JDK_DIR" "$EXTRACT_DIR"
    mkdir -p "$EXTRACT_DIR"
    tar -xzf "$JDK_FILE" -C "$EXTRACT_DIR"
    rm -f "$JDK_FILE"
    INNER=$(find "$EXTRACT_DIR" -maxdepth 1 -type d -name 'jdk-*' | head -1)
    if [ -z "$INNER" ] || [ ! -x "$INNER/bin/java" ]; then
        echo "[ERROR] No se encontro java despues de extraer."
        return 1
    fi
    mv "$INNER" "$JDK_DIR"
    rmdir "$EXTRACT_DIR" 2>/dev/null
    if [ ! -x "$JDK_DIR/bin/java" ]; then
        echo "[ERROR] Instalacion fallo."
        return 1
    fi
    echo "[OK] JDK 21 instalado en $JDK_DIR"
    return 0
}
