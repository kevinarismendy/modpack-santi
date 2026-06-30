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
fc /b "%~dp0launcher.bat" "%TEMP_LAUNCHER%" >nul 2>nul
if errorlevel 1 (
    echo       Launcher actualizado. La proxima corrida usara la version nueva.
    copy /y "%TEMP_LAUNCHER%" "%~dp0launcher.bat" >nul 2>nul
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

REM --- TLauncher (no-premium) ---
echo [2/4] Verificando TLauncher...
if exist "%LOCALAPPDATA%\TLauncher\tlauncher.exe" goto :tlauncher_ok
if exist "%LOCALAPPDATA%\Programs\TLauncher\tlauncher.exe" goto :tlauncher_ok
if exist "C:\Program Files\TLauncher\tlauncher.exe" goto :tlauncher_ok
echo       Descargando TLauncher (~26 MB, desde GitHub)...
set "TLAUNCHER_SETUP=%TEMP%\TLauncher-Setup.exe"
curl.exe -L -o "%TLAUNCHER_SETUP%" "https://github.com/kevinarismendy/modpack-santi/releases/download/tlauncher-v1/TLauncher-Setup.exe" --max-time 180
if errorlevel 1 goto :tlauncher_fail
echo       Ejecutando instalador (espera a que termine, puede tardar 1-2 min)...
start /wait "" "%TLAUNCHER_SETUP%" /quiet
if exist "%LOCALAPPDATA%\TLauncher\tlauncher.exe" goto :tlauncher_ok
if exist "%LOCALAPPDATA%\Programs\TLauncher\tlauncher.exe" goto :tlauncher_ok
if exist "C:\Program Files\TLauncher\tlauncher.exe" goto :tlauncher_ok
:tlauncher_fail
echo       [WARN] Descarga/instalacion fallo. Baja TLauncher desde:
echo       https://tlauncher.org/en/
goto :tlauncher_done
:tlauncher_ok
echo       [OK] TLauncher listo
:tlauncher_done

REM --- Crear instancia de TLauncher automaticamente ---
echo [3/4] Creando instancia "Servidor Amiguos" en TLauncher...
set "TLAUNCHER_ROOT=%APPDATA%\TLauncher"
if not exist "%TLAUNCHER_ROOT%" set "TLAUNCHER_ROOT=%LOCALAPPDATA%\TLauncher"
if not exist "%TLAUNCHER_ROOT%" goto :skip_instance
if not exist "%BOOTSTRAP_JAR%" (
    echo       Descargando bootstrap...
    curl.exe -L -o %BOOTSTRAP_JAR% "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
)
if not exist "%BOOTSTRAP_JAR%" goto :skip_instance
set "INSTANCE=%TLAUNCHER_ROOT%\instances\Servidor Amiguos"
set "MODS_TEMP=%TEMP%\santicraft-mods"
if exist "%INSTANCE%" goto :skip_instance
echo       Bajando mods (91 MB) a %MODS_TEMP%...
mkdir "%MODS_TEMP%"
"%JAVA_CMD%" -jar %BOOTSTRAP_JAR% -g %BOOTSTRAP_URL%
if exist "%MODS_TEMP%\minecraft\mods" (
    mkdir "%INSTANCE%\.minecraft\mods"
    xcopy /E /Y "%MODS_TEMP%\minecraft\mods\*" "%INSTANCE%\.minecraft\mods\" >nul
    copy /Y "%BOOTSTRAP_JAR%" "%INSTANCE%\.minecraft\packwiz-installer-bootstrap.jar" >nul 2>&1
    (
        echo InstanceType=OneSix
        echo name=Servidor Amiguos
        echo iconKey=grass_block
    ) > "%INSTANCE%\instance.cfg"
    echo       [OK] Instancia creada
) else (
    echo       [WARN] No se pudieron bajar los mods. La instancia tendra que crearse manual.
)
:skip_instance

REM --- Bootstrap jar ---
if not exist %BOOTSTRAP_JAR% (
    echo [3/4] Descargando bootstrap...
    curl.exe -L -sS -o %BOOTSTRAP_JAR% "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
)

REM --- Instalar mods ---
echo [4/4] Instalando mods desde el repo oficial...
echo       (primera vez puede tardar varios minutos, ~91 MB)
echo.
if exist "%INSTANCE%\.minecraft\mods" (
    echo       Mods ya en la instancia de TLauncher. Re-ejecuta el launcher para actualizarlos.
    "%JAVA_CMD%" -jar %BOOTSTRAP_JAR% -g %BOOTSTRAP_URL% 2>nul
) else (
    "%JAVA_CMD%" -jar %BOOTSTRAP_JAR% -g %BOOTSTRAP_URL%
)
echo.
echo ============================================
echo   Listo.
echo   1) Abre TLauncher desde el acceso directo del escritorio
echo   2) Click "Entrar al juego" o "Login"
echo      (escribe cualquier username, sin password)
echo   3) Crea instancia 1.21.1 + NeoForge 21.1.234
echo   4) Conectate a: %SERVER%
echo ============================================
echo.
echo   Los mods y Java ya estan listos.
echo.
echo   Para buscar updates: doble-click "Servidor Amiguos - Actualizar"
echo   o vuelve a correr launcher.bat desde esta carpeta.
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
