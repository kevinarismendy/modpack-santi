@echo off
chcp 65001 >nul
setlocal EnableExtensions
title Servidor Amiguos - Modpack Installer
cd /d "%~dp0"

set MIN_JAVA=21
set JDK_DIR=%LOCALAPPDATA%\jdk21
set EXTRACT_DIR=%LOCALAPPDATA%\jdk_extract_temp
set BOOTSTRAP_URL=https://cdn.jsdelivr.net/gh/kevinarismendy/modpack-santi@main/pack.toml
set BOOTSTRAP_JAR=packwiz-installer-bootstrap.jar
set PRISM_URL=https://github.com/kevinarismendy/modpack-santi/releases/download/prismlauncher-v1/PrismLauncher-Windows.zip
set SERVER=amiguos.holy.gg

echo ============================================
echo   Servidor Amiguos - Modpack Installer
echo   MC 1.21.1 + NeoForge 21.1.234
echo ============================================
echo.

REM --- [Pre] Auto-actualizar el launcher para la proxima corrida ---
echo [Pre] Verificando actualizaciones del launcher...
set "TEMP_LAUNCHER=%TEMP%\santicraft_launcher_%RANDOM%.bat"
curl.exe -L -sS -o "%TEMP_LAUNCHER%" "%LAUNCHER_URL%" 2>nul
if not exist "%TEMP_LAUNCHER%" goto :launcher_done
fc /b "%~dp0launcher.bat" "%TEMP_LAUNCHER%" >nul 2>&1
if errorlevel 1 (
    echo       Launcher actualizado. La proxima corrida usara la version nueva.
    copy /y "%TEMP_LAUNCHER%" "%~dp0launcher.bat" >nul
) else (
    echo       Launcher al dia.
)
del "%TEMP_LAUNCHER%" 2>nul
:launcher_done
echo.

REM --- Localizar Java 21+ ---
set "JAVA_CMD="
where java >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=2 delims=" %%v in ('"java -version 2>&1" ^| findstr /i "version"') do (
        for /f "delims=. tokens=1" %%m in ("%%~v") do (
            if %%m geq %MIN_JAVA% set "JAVA_CMD=java"
        )
    )
)

if not defined JAVA_CMD (
    if exist "%JDK_DIR%\bin\java.exe" (
        echo [1/4] [OK] Usando JDK portable en %JDK_DIR%
        set "JAVA_CMD=%JDK_DIR%\bin\java.exe"
    ) else (
        echo [1/4] [!] Java %MIN_JAVA%+ no encontrado. Instalando portable...
        call :install_jdk_windows
        if errorlevel 1 (
            echo [ERROR] No se pudo instalar Java automaticamente.
            echo Descargalo manualmente desde https://adoptium.net/ y volve a correr.
            pause
            exit /b 1
        )
        set "JAVA_CMD=%JDK_DIR%\bin\java.exe"
    )
) else (
    for /f "tokens=2 delims=" %%v in ('"java -version 2>&1" ^| findstr /i "version"') do echo [1/4] [OK] Java %%v detectado
)

REM --- PrismLauncher (auto via winget) ---
echo [2/4] Verificando PrismLauncher...
where PrismLauncher.exe >nul 2>&1
if not errorlevel 1 (
    echo       [OK] PrismLauncher ya instalado
) else (
    echo       Instalando PrismLauncher con winget (~1 min)...
    winget install --exact --id PrismLauncher.PrismLauncher --accept-package-agreements --accept-source-agreements --silent
    if errorlevel 1 (
        echo       [WARN] winget fallo. Si tenes problemas, instalalo manualmente desde:
        echo       https://prismlauncher.org/choose/
    ) else (
        echo       [OK] PrismLauncher instalado
    )
)

REM --- Bootstrap jar ---
if not exist %BOOTSTRAP_JAR% (
    echo [3/4] Descargando bootstrap...
    curl.exe -L -sS -o %BOOTSTRAP_JAR% "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
)

REM --- Instalar mods ---
echo [4/4] Instalando mods desde el repo oficial...
echo       (primera vez puede tardar varios minutos, ~91 MB)
echo.
"%JAVA_CMD%" -jar %BOOTSTRAP_JAR% -g %BOOTSTRAP_URL%
echo.
echo ============================================
echo   Listo.
echo   1) Instala PrismLauncher desde https://prismlauncher.org/choose/
echo   2) Abre PrismLauncher y crea perfil MC 1.21.1 + NeoForge 21.1.234
echo   3) Conectate a: %SERVER%
echo ============================================
echo.
echo   Los mods y Java ya estan listos.
echo.
echo   Para buscar updates en el futuro: vuelve a correr launcher.bat
echo   desde esta carpeta.
echo.
exit /b 0

REM ========== Instalador portable de JDK 21 ==========
:install_jdk_windows
set "JDK_ZIP=%TEMP%\servidor_amigos_jdk.zip"
set "JDK_URL=https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jdk/hotspot/normal/eclipse"
echo Descargando JDK 21 (portable) desde Adoptium...
curl.exe -L -sS -o "%JDK_ZIP%" "%JDK_URL%"
if errorlevel 1 (
    echo [ERROR] No se pudo descargar JDK.
    exit /b 1
)
echo Extrayendo JDK ...
if exist "%JDK_DIR%" rmdir /s /q "%JDK_DIR%"
if exist "%EXTRACT_DIR%" rmdir /s /q "%EXTRACT_DIR%"
mkdir "%EXTRACT_DIR%"
powershell -NoProfile -Command "Expand-Archive -LiteralPath '%JDK_ZIP%' -DestinationPath '%EXTRACT_DIR%' -Force" >nul
del "%JDK_ZIP%" 2>nul
for /d %%D in ("%EXTRACT_DIR%\*") do (
    if exist "%%D\bin\java.exe" (
        robocopy "%%D" "%JDK_DIR%" /E /MOVE /NFL /NDL /NJH /NJS /NC /NS >nul 2>&1
    )
)
rmdir "%EXTRACT_DIR%" 2>nul
if not exist "%JDK_DIR%\bin\java.exe" (
    echo [ERROR] No se encontro java.exe despues de extraer.
    exit /b 1
)
echo [OK] JDK 21 instalado en %JDK_DIR%
exit /b 0
