#!/bin/bash
cd "$(dirname "$0")"

MIN_JAVA=21
JDK_DIR="$HOME/.jdk21"
EXTRACT_DIR="/tmp/jdk_extract_temp"
BOOTSTRAP_URL="https://cdn.jsdelivr.net/gh/kevinarismendy/modpack-santi@main/pack.toml"
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

# --- HMCL (auto para Windows/Mac/Linux) ---
echo "[2/4] Verificando HMCL..."
HMCL_DIR="$HOME/Library/Application Support/HMCL"
if [ "$(uname)" != "Darwin" ] && [ "$(uname)" != "Linux" ]; then
    echo "      [WARN] OS no soportado. Instala HMCL desde https://hmcl.huangyuhui.net/download/"
    return 0
fi
if [ -d "$HMCL_DIR" ] && [ -f "$HMCL_DIR/HMCL.jar" ]; then
    echo "      [OK] HMCL ya instalado en $HMCL_DIR"
elif [ "$(uname)" = "Darwin" ]; then
    echo "      Descargando HMCL para Mac (~10 MB)..."
    mkdir -p "$HMCL_DIR"
    curl -L -sS -o "$HMCL_DIR/HMCL.jar" "https://github.com/huanghongxun/HMCL/releases/download/v3.15.2/HMCL-3.15.2.jar" --max-time 120
    cat > "$HMCL_DIR/HMCL.command" <<'HMCL_EOF'
#!/bin/bash
cd "$(dirname "$0")"
java -jar HMCL.jar
HMCL_EOF
    chmod +x "$HMCL_DIR/HMCL.command"
    if [ -f "$HMCL_DIR/HMCL.jar" ]; then
        echo "      [OK] HMCL instalado en $HMCL_DIR"
    else
        echo "      [WARN] Descarga fallo. Baja desde https://hmcl.huangyuhui.net/download/"
    fi
else
    echo "      Descargando HMCL Linux AppImage (~105 MB)..."
    mkdir -p "$HMCL_DIR"
    APPIMAGE="$HMCL_DIR/HMCL-x86_64.AppImage"
    curl -L -sS -o "$APPIMAGE" "https://github.com/huanghongxun/HMCL/releases/download/v3.15.2/HMCL-3.15.2-x86_64.AppImage" --max-time 300
    chmod +x "$APPIMAGE"
    cat > "$HMCL_DIR/HMCL.sh" <<'HMCL_EOF'
#!/bin/bash
cd "$(dirname "$0")"
./HMCL-x86_64.AppImage "$@"
HMCL_EOF
    chmod +x "$HMCL_DIR/HMCL.sh"
    if [ -f "$APPIMAGE" ]; then
        echo "      [OK] HMCL instalado en $HMCL_DIR"
    else
        echo "      [WARN] Descarga fallo. Baja desde https://hmcl.huangyuhui.net/download/"
    fi
fi

# --- Bootstrap jar ---
if [ ! -f "$BOOTSTRAP_JAR" ]; then
    echo "[3/4] Descargando bootstrap..."
    curl -L -sS -o "$BOOTSTRAP_JAR" "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
fi

# --- Instalar mods ---
echo "[4/4] Instalando mods desde el repo oficial..."
echo "      (primera vez puede tardar varios minutos, ~91 MB)"
echo ""
$JAVA_CMD -version
echo ""
$JAVA_CMD -jar "$BOOTSTRAP_JAR" -g "$BOOTSTRAP_URL"
echo ""
echo "============================================"
echo "  Listo."
echo "  1) Instala PrismLauncher desde https://prismlauncher.org/choose/"
echo "  2) Abre PrismLauncher y crea perfil MC 1.21.1 + NeoForge 21.1.234"
echo "  3) Conectate a: $SERVER"
echo "============================================"
echo ""
echo "  Los mods y Java ya estan listos."
echo ""
echo "  Para buscar updates en el futuro: vuelve a correr launcher.sh."
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

