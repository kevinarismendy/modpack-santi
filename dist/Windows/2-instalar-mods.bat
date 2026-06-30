@echo off
setlocal EnableExtensions EnableDelayedExpansion
title [2/3] Instalar Mods
cd /d "%~dp0"

set MIN_JAVA=21
set JDK_DIR=%LOCALAPPDATA%\jdk21
set EXTRACT_DIR=%LOCALAPPDATA%\jdk_extract_temp
set BOOTSTRAP_URL=https://cdn.jsdelivr.net/gh/kevinarismendy/modpack-santi@main/pack.toml
set BOOTSTRAP_JAR=packwiz-installer-bootstrap.jar
set SERVER=amiguos.holy.gg

echo ============================================
echo   [2/3] Instalador de Mods
echo   MC 1.21.1 + Fabric 0.16.5
echo ============================================
echo.

set "TLAUNCHER_EXE="
if exist "%APPDATA%\.tlauncher\tlauncher.exe" set "TLAUNCHER_EXE=%APPDATA%\.tlauncher\tlauncher.exe"
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.tlauncher\TLauncher.exe" set "TLAUNCHER_EXE=%APPDATA%\.tlauncher\TLauncher.exe"
if not defined TLAUNCHER_EXE if exist "%LOCALAPPDATA%\TLauncher\tlauncher.exe" set "TLAUNCHER_EXE=%LOCALAPPDATA%\TLauncher\tlauncher.exe"
if not defined TLAUNCHER_EXE if exist "%LOCALAPPDATA%\TLauncher\TLauncher.exe" set "TLAUNCHER_EXE=%LOCALAPPDATA%\TLauncher\TLauncher.exe"
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.minecraft\TLauncher.exe" set "TLAUNCHER_EXE=%APPDATA%\.minecraft\TLauncher.exe"
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.minecraft\tlauncher.exe" set "TLAUNCHER_EXE=%APPDATA%\.minecraft\tlauncher.exe"

if not defined TLAUNCHER_EXE (
    echo [ERROR] TLauncher no esta instalado.
    echo Primero corre "1-instalar-tlauncher.bat"
    pause
    exit /b 1
)
echo [OK] TLauncher: !TLAUNCHER_EXE!
echo.

REM --- Detectar Java 21+ ---
echo Detectando Java...
set "JAVA_CMD="
set "JAVA_VERSION="
where java >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=2 delims= " %%v in ('"java -version 2>&1" ^| findstr /i "version"') do (
        for /f "tokens=1 delims=." %%a in ("%%~v") do (
            for /f "delims=""" %%b in ("%%a") do (
                set "JAVA_VERSION=%%b"
                if !JAVA_VERSION! geq %MIN_JAVA% set "JAVA_CMD=java"
            )
        )
    )
)
if defined JAVA_CMD (
    echo [OK] Java !JAVA_VERSION! detectado
) else (
    if exist "%JDK_DIR%\bin\java.exe" (
        echo [OK] JDK 21 portable en %JDK_DIR%
        set "JAVA_CMD=%JDK_DIR%\bin\java.exe"
    ) else (
        echo [!] Java 21+ no encontrado. Bajando JDK 21 portable...
        set "JDK_ZIP=%TEMP%\servidor_amigos_jdk.zip"
        set "JDK_URL=https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jdk/hotspot/normal/eclipse"
        echo       Descargando...
        curl.exe -L -sS -o "%JDK_ZIP%" "%JDK_URL%"
        if errorlevel 1 (
            echo [ERROR] No se pudo bajar JDK.
            echo Instala Java 21 desde https://adoptium.net/ y volve a correr.
            pause
            exit /b 1
        )
        echo       Extrayendo...
        if exist "%JDK_DIR%" rmdir /s /q "%JDK_DIR%" 2>nul
        if exist "%EXTRACT_DIR%" rmdir /s /q "%EXTRACT_DIR%" 2>nul
        mkdir "%EXTRACT_DIR%" 2>nul
        powershell -NoProfile -Command "Expand-Archive -LiteralPath '%JDK_ZIP%' -DestinationPath '%EXTRACT_DIR%' -Force" >nul 2>&1
        del "%JDK_ZIP%" 2>nul
        for /d %%D in ("%EXTRACT_DIR%\*") do (
            if exist "%%D\bin\java.exe" (
                robocopy "%%D" "%JDK_DIR%" /E /MOVE /NFL /NDL /NJH /NJS /NC /NS >nul 2>&1
            )
        )
        rmdir "%EXTRACT_DIR%" 2>nul
        if not exist "%JDK_DIR%\bin\java.exe" (
            echo [ERROR] No se encontro java.exe despues de extraer.
            pause
            exit /b 1
        )
        echo       [OK] JDK 21 en %JDK_DIR%
        set "JAVA_CMD=%JDK_DIR%\bin\java.exe"
    )
)
echo.

REM --- Bootstrap ---
if not exist "%BOOTSTRAP_JAR%" (
    echo Descargando packwiz bootstrap...
    curl.exe -L -sS -o "%BOOTSTRAP_JAR%" "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
    if errorlevel 1 (
        echo [ERROR] No se pudo bajar el bootstrap.
        pause
        exit /b 1
    )
)
echo [OK] Bootstrap listo
echo.

REM --- Bajar mods ---
echo Descargando 40 mods a una carpeta temporal...
set "MODS_TEMP=%TEMP%\santicraft-mods-%RANDOM%"
mkdir "!MODS_TEMP!" 2>nul
pushd "!MODS_TEMP!"
"!JAVA_CMD!" -jar "%~dp0%BOOTSTRAP_JAR%" -g %BOOTSTRAP_URL%
set BOOTSTRAP_RC=!errorlevel!
popd
if !BOOTSTRAP_RC! neq 0 (
    echo [ERROR] Fallo la descarga de mods.
    rmdir /s /q "!MODS_TEMP!" 2>nul
    pause
    exit /b 1
)
if not exist "!MODS_TEMP!\minecraft\mods" (
    echo [ERROR] No se encontraron mods descargados.
    rmdir /s /q "!MODS_TEMP!" 2>nul
    pause
    exit /b 1
)

REM --- Copiar mods ---
set "MODS_DEST="
if exist "%APPDATA%\.minecraft\mods" set "MODS_DEST=%APPDATA%\.minecraft\mods"
if not defined MODS_DEST if exist "%APPDATA%\.minecraft" set "MODS_DEST=%APPDATA%\.minecraft\mods"
if not defined MODS_DEST set "MODS_DEST=%LOCALAPPDATA%\TLauncher\mods"
if not exist "!MODS_DEST!" mkdir "!MODS_DEST!" 2>nul
echo.
echo Copiando mods a !MODS_DEST! ...
xcopy /E /Y /Q "!MODS_TEMP!\minecraft\mods\*" "!MODS_DEST!\" >nul 2>&1
rmdir /s /q "!MODS_TEMP!" 2>nul
echo [OK] Mods instalados.
echo.

echo ============================================
echo   Listo. Ya podes jugar.
echo.
echo   1) Abre TLauncher
echo   2) Login con cualquier username (no-premium)
echo   3) Crea perfil: 1.21.1 + Fabric 0.16.5
echo   4) Conectate a: %SERVER%
echo ============================================
echo.
pause
exit /b 0
