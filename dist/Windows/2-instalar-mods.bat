@echo off
setlocal EnableExtensions EnableDelayedExpansion
title [2/3] Instalar Mods
cd /d "%~dp0"

set MIN_JAVA=21
set JDK_DIR=%LOCALAPPDATA%\jdk21
set EXTRACT_DIR=%LOCALAPPDATA%\jdk_extract_temp
set RAW_BASE=https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main
set CACHE_BUST=%RANDOM%%RANDOM%
set BOOTSTRAP_URL=%RAW_BASE%/pack.toml?cb=%CACHE_BUST%
set BOOTSTRAP_JAR_URL=%RAW_BASE%/packwiz-installer-bootstrap.jar?cb=%CACHE_BUST%
set BOOTSTRAP_JAR=packwiz-installer-bootstrap.jar
set SERVER=amiguos.holy.gg

echo ============================================
echo   [2/3] Instalador de Mods
echo   MC 1.21.1 + Fabric 0.16.5
echo ============================================
echo.

REM --- Detectar TLauncher ---
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
where java >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=2 delims= " %%v in ('"java -version 2>&1" ^| findstr /i "version"') do (
        for /f "tokens=1 delims=." %%a in ("%%~v") do (
            for /f "delims=""" %%b in ("%%a") do (
                if %%b geq %MIN_JAVA% set "JAVA_CMD=java"
            )
        )
    )
)
if defined JAVA_CMD (
    echo [OK] Java detectado
) else (
    if exist "%JDK_DIR%\bin\java.exe" (
        echo [OK] JDK 21 portable en %JDK_DIR%
        set "JAVA_CMD=%JDK_DIR%\bin\java.exe"
    ) else (
        echo [!] Java 21+ no encontrado. Bajando JDK 21 portable...
        set "JDK_ZIP=%TEMP%\servidor_amigos_jdk.zip"
        curl.exe -L -sS -o "%JDK_ZIP%" "https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jdk/hotspot/normal/eclipse"
        if errorlevel 1 (
            echo [ERROR] No se pudo bajar JDK.
            echo Instala Java 21 desde https://adoptium.net/ y volve a correr.
            pause
            exit /b 1
        )
        if exist "%JDK_DIR%" rmdir /s /q "%JDK_DIR%" 2>nul
        if exist "%EXTRACT_DIR%" rmdir /s /q "%EXTRACT_DIR%" 2>nul
        mkdir "%EXTRACT_DIR%" 2>nul
        powershell -NoProfile -Command "Expand-Archive -LiteralPath '%JDK_ZIP%' -DestinationPath '%EXTRACT_DIR%' -Force" >nul 2>&1
        del "%JDK_ZIP%" 2>nul
        for /d %%D in ("%EXTRACT_DIR%\*") do (
            if exist "%%D\bin\java.exe" robocopy "%%D" "%JDK_DIR%" /E /MOVE /NFL /NDL /NJH /NJS /NC /NS >nul 2>&1
        )
        rmdir "%EXTRACT_DIR%" 2>nul
        if not exist "%JDK_DIR%\bin\java.exe" (
            echo [ERROR] No se encontro java.exe despues de extraer.
            pause
            exit /b 1
        )
        set "JAVA_CMD=%JDK_DIR%\bin\java.exe"
        echo [OK] JDK 21 portable listo
    )
)
echo.

REM --- Verificar conexion al servidor de modpack ---
echo Verificando GitHub...
curl.exe -L -sS -o nul -w "" "%BOOTSTRAP_URL%" --max-time 10
if errorlevel 1 (
    echo [ERROR] No se puede conectar a GitHub.
    echo Verifica tu conexion a internet.
    pause
    exit /b 1
)
echo [OK] GitHub accesible
echo.

REM --- Bajar packwiz-installer-bootstrap.jar ---
if not exist "%BOOTSTRAP_JAR%" (
    echo Descargando packwiz bootstrap...
    curl.exe -L -sS -o "%BOOTSTRAP_JAR%" "%BOOTSTRAP_JAR_URL%" --max-time 60
    if errorlevel 1 (
        echo [ERROR] No se pudo bajar el bootstrap.
        pause
        exit /b 1
    )
)
echo [OK] Bootstrap listo
echo.

REM --- Limpiar cache viejo del bootstrap en TEMP ---
if exist "%TEMP%\pack.toml" del "%TEMP%\pack.toml" 2>nul
if exist "%TEMP%\pw_zip" rmdir /s /q "%TEMP%\pw_zip" 2>nul
if exist "%TEMP%\pw_test" rmdir /s /q "%TEMP%\pw_test" 2>nul

REM --- Bajar mods via packwiz-installer ---
echo Descargando 31 mods Fabric desde GitHub (cache-bust)...
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
if not exist "!MODS_TEMP!\mods" (
    if not exist "!MODS_TEMP!\minecraft\mods" (
        echo [ERROR] No se encontraron mods descargados.
        rmdir /s /q "!MODS_TEMP!" 2>nul
        pause
        exit /b 1
    )
    set "MODS_SOURCE=!MODS_TEMP!\minecraft\mods"
) else (
    set "MODS_SOURCE=!MODS_TEMP!\mods"
)

REM --- Copiar mods a la carpeta global de TLauncher ---
set "MODS_DEST="
if exist "%APPDATA%\.minecraft\mods" set "MODS_DEST=%APPDATA%\.minecraft\mods"
if not defined MODS_DEST if exist "%APPDATA%\.minecraft" set "MODS_DEST=%APPDATA%\.minecraft\mods"
if not defined MODS_DEST set "MODS_DEST=%LOCALAPPDATA%\TLauncher\mods"
if not exist "!MODS_DEST!" mkdir "!MODS_DEST!" 2>nul
echo.
echo Copiando mods a !MODS_DEST! ...
xcopy /E /Y /Q "!MODS_SOURCE!\*" "!MODS_DEST!\" >nul 2>&1
rmdir /s /q "!MODS_TEMP!" 2>nul
echo [OK] Mods instalados en carpeta global.
echo.

REM --- Tambien copiar a cada version/perfil de TLauncher ---
set "VERSIONS_DIR=%APPDATA%\.minecraft\versions"
set "VERSION_COUNT=0"
if exist "!VERSIONS_DIR!" (
    echo Copiando mods a perfiles de TLauncher...
    for /d %%V in ("!VERSIONS_DIR!\*") do (
        if exist "%%V\minecraft" (
            if not exist "%%V\minecraft\mods" mkdir "%%V\minecraft\mods" 2>nul
            xcopy /E /Y /Q "!MODS_DEST!\*.jar" "%%V\minecraft\mods\" >nul 2>&1
            set /a VERSION_COUNT+=1
            echo   - %%~nxV
        )
    )
    if !VERSION_COUNT! gtr 0 (
        echo [OK] Copiado a !VERSION_COUNT! perfil(es) de TLauncher.
    ) else (
        echo [!] No se encontraron perfiles en versions\
    )
)
echo.

echo ============================================
echo   Listo. Ya podes jugar.
echo.
echo   Los mods se copiaron a:
echo     - Carpeta global: !MODS_DEST!
if !VERSION_COUNT! gtr 0 (
    echo     - !VERSION_COUNT! perfil(es) de TLauncher
)
echo.
echo   1) Abre TLauncher
echo   2) Login con cualquier username (no-premium)
echo   3) Selecciona el perfil "Amigous" o "Fabric 1.21.1"
echo   4) Conectate a: %SERVER%
echo ============================================
echo.
pause
exit /b 0
