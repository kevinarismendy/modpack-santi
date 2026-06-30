#!/bin/bash
cd "$(dirname "$0")"

MIN_JAVA=21
JDK_DIR="$HOME/.jdk21"
EXTRACT_DIR="/tmp/jdk_extract_temp"
BOOTSTRAP_URL="https://cdn.jsdelivr.net/gh/kevinarismendy/modpack-santi@main/pack.toml"
LAUNCHER_URL="https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main/dist/launcher.sh"
HMCL_URL="https://github.com/kevinarismendy/modpack-santi/releases/download/hmcl-v1/HMCL-3.15.2.zip"
BOOTSTRAP_JAR="packwiz-installer-bootstrap.jar"
PRISM_URL="https://github.com/kevinarismendy/modpack-santi/releases/download/prismlauncher-v1/PrismLauncher-Linux.tar.gz"
PRISM_INSTALLED=0
SERVER="amiguos.holy.gg"

echo "============================================"
echo "  Servidor Amiguos - Modpack Installer"
echo "  MC 1.21.1 + NeoForge 21.1.234"
echo "============================================"
echo ""

# --- [Pre] Auto-actualizar el launcher para la proxima corrida ---
echo "[Pre] Verificando actualizaciones del launcher..."
TEMP_LAUNCHER="/tmp/santicraft_launcher_$$.sh"
if curl -L -sS -o "$TEMP_LAUNCHER" "$REPO/launcher.sh" 2>/dev/null && [ -s "$TEMP_LAUNCHER" ]; then
    if ! cmp -s "$0" "$TEMP_LAUNCHER"; then
        echo "      Launcher actualizado. (proxima corrida usara la nueva version)"
        cp "$TEMP_LAUNCHER" "$0"
    else
        echo "      Launcher al dia."
    fi
    rm "$TEMP_LAUNCHER"
else
    echo "      [WARN] No se pudo verificar."
fi
echo ""

# --- Localizar Java 21+ ---
JAVA_CMD=""
if command -v java &> /dev/null; then
    JAVA_VER=$(java -version 2>&1 | head -1 | sed -E 's/.*"([0-9]+)\.([0-9]+)\..*/\1/')
    if [ "$JAVA_VER" -ge "$MIN_JAVA" ] 2>/dev/null; then
        echo "[1/4] [OK] Java $JAVA_VER detectado"
        JAVA_CMD="java"
    fi
fi

if [ -z "$JAVA_CMD" ]; then
    if [ -x "$JDK_DIR/bin/java" ]; then
        echo "[1/4] [OK] Usando JDK portable en $JDK_DIR"
        JAVA_CMD="$JDK_DIR/bin/java"
    else
        echo "[1/4] [!] Java $MIN_JAVA+ no encontrado. Instalando portable..."
        install_jdk_unix
        if [ $? -ne 0 ]; then
            echo "[ERROR] No se pudo instalar Java automaticamente."
            echo "Descargalo manualmente desde https://adoptium.net/ y volve a correr."
            exit 1
        fi
        JAVA_CMD="$JDK_DIR/bin/java"
    fi
fi

# --- HMCL (no-premium, soporta NeoForge) ---
echo "[2/4] Verificando HMCL..."
HMCL_DIR="$HOME/.local/share/HMCL"
if [ "$(uname)" = "Darwin" ]; then
    HMCL_DIR="$HOME/Library/Application Support/HMCL"
fi
if [ -f "$HMCL_DIR/HMCL" ] || [ -f "$HMCL_DIR/HMCL.exe" ]; then
    echo "      [OK] HMCL ya instalado en $HMCL_DIR"
else
    echo "      Descargando HMCL (~26 MB, desde GitHub)..."
    mkdir -p "$HMCL_DIR"
    HMCL_ZIP="/tmp/hmcl.zip"
    curl -L --progress-bar -o "$HMCL_ZIP" "$HMCL_URL" --max-time 180
    if [ -s "$HMCL_ZIP" ]; then
        unzip -q -o "$HMCL_ZIP" -d "$HMCL_DIR"
        chmod +x "$HMCL_DIR/HMCL" 2>/dev/null
        rm "$HMCL_ZIP"
        echo "      [OK] HMCL instalado en $HMCL_DIR"
    else
        echo "      [WARN] Descarga fallo. Baja HMCL desde:"
        echo "      https://hmcl.huangyuhui.net/download/"
    fi
fi

# --- Bootstrap jar ---
if [ ! -f "$BOOTSTRAP_JAR" ]; then
    echo "[3/4] Descargando bootstrap..."
    curl -L -sS -o "$BOOTSTRAP_JAR" "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
fi

# --- Crear instancia de HMCL automaticamente ---
echo "[4/4] Creando instancia 'Servidor Amiguos'..."
if [ -d "$HMCL_DIR/instances" ] && [ ! -d "$HMCL_DIR/instances/Servidor Amiguos" ]; then
    INSTANCE="$HMCL_DIR/instances/Servidor Amiguos"
    MODS_TEMP="/tmp/santicraft-mods"
    echo "      Bajando mods a $MODS_TEMP..."
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
    if [ -d "$HMCL_DIR/instances/Servidor Amiguos" ]; then
        echo "      Instancia ya existe."
    fi
fi

# --- Instalar mods (solo si no hay instancia de HMCL) ---
if [ ! -d "$HMCL_DIR/instances/Servidor Amiguos" ]; then
    echo "      Instalando mods en .minecraft/ default..."
    $JAVA_CMD -jar "$BOOTSTRAP_JAR" -g "$BOOTSTRAP_URL"
fi
echo ""
echo "============================================"
echo "  Listo."
if [ "$(uname)" = "Darwin" ]; then
    echo "  1) Abre TLauncher: ~/Library/Application Support/TLauncher/TLauncher.command"
else
    echo "  1) Abre TLauncher: $HOME/.local/share/TLauncher/tlauncher"
fi
echo "  2) Login con cualquier username (sin password)"
echo "  3) Crea instancia 1.21.1 + NeoForge 21.1.234 (o usa la que ya creo el script)"
echo "  4) Conectate a: $SERVER"
echo "============================================"
echo ""
echo "  Los mods y Java ya estan listos."
echo ""
echo "  Para buscar updates: vuelve a correr launcher.sh."
echo ""
echo "============================================"

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
        JDK_FILE="$TMPDIR/servidor_amigos_jdk.tar.gz"
    else
        JDK_FILE="/tmp/servidor_amigos_jdk.tar.gz"
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

