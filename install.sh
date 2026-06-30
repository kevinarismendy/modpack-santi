#!/bin/bash
cd "$(dirname "$0")"

MIN_JAVA=21
JDK_DIR="$HOME/.jdk21"
EXTRACT_DIR="/tmp/jdk_extract_temp"
BOOTSTRAP_URL="https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main/pack.toml"
BOOTSTRAP_JAR="packwiz-installer-bootstrap.jar"

echo "============================================"
echo "  Servidor Amiguos - Modpack Installer"
echo "  MC 1.21.1 + NeoForge 21.1.234"
echo "============================================"
echo ""

# --- Localizar Java 21+ ---
JAVA_CMD=""
if command -v java &> /dev/null; then
    JAVA_VER=$(java -version 2>&1 | head -1 | sed -E 's/.*"([0-9]+)\.([0-9]+)\..*/\1/')
    if [ "$JAVA_VER" -ge "$MIN_JAVA" ] 2>/dev/null; then
        echo "[OK] Java $JAVA_VER detectado"
        JAVA_CMD="java"
    fi
fi

if [ -z "$JAVA_CMD" ]; then
    if [ -x "$JDK_DIR/bin/java" ]; then
        echo "[OK] Usando JDK portable en $JDK_DIR"
        JAVA_CMD="$JDK_DIR/bin/java"
    else
        echo "[!] Java $MIN_JAVA+ no encontrado. Instalando portable..."
        install_jdk_unix
        if [ $? -ne 0 ]; then
            echo "[ERROR] No se pudo instalar Java automaticamente."
            echo "Descargalo manualmente desde https://adoptium.net/ y volve a correr."
            exit 1
        fi
        JAVA_CMD="$JDK_DIR/bin/java"
    fi
fi

if [ ! -f "$BOOTSTRAP_JAR" ]; then
    echo "Descargando bootstrap..."
    curl -L -sS -o "$BOOTSTRAP_JAR" "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
fi

echo ""
echo "Instalando mods desde el repo oficial..."
echo "(primera vez puede tardar varios minutos, ~91 MB)"
echo ""
$JAVA_CMD -version
echo ""
$JAVA_CMD -jar "$BOOTSTRAP_JAR" -g "$BOOTSTRAP_URL"
echo ""
echo "============================================"
echo "  Listo."
echo "  1) Lanza MC desde UltimMC con perfil 1.21.1 + NeoForge 21.1.234"
echo "  2) Conectate a: mc.santiagoarismendy.com"
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
    # Mover la subcarpeta jdk-* extraida a JDK_DIR
    INNER=$(find "$EXTRACT_DIR" -maxdepth 1 -type d -name 'jdk-*' | head -1)
    if [ -z "$INNER" ] || [ ! -x "$INNER/bin/java" ]; then
        echo "[ERROR] No se encontro java.exe despues de extraer."
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
