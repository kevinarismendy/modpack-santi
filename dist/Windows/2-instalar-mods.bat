@echo off
setlocal EnableExtensions EnableDelayedExpansion
title [2/3] Instalar Mods
cd /d "%~dp0"

set MIN_JAVA=21
set JDK_DIR=%LOCALAPPDATA%\jdk21
set EXTRACT_DIR=%LOCALAPPDATA%\jdk_extract_temp
set MODS_LIST_URL=https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main/mods.csv
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

REM --- Bajar lista de mods (mods.csv) ---
set "MODS_LIST=%TEMP%\servidor-amiguos-mods-%RANDOM%.csv"
echo Descargando lista de mods...
REM Timestamp para bypasear cache de GitHub raw
set "CACHE_BUST=%RANDOM%%RANDOM%"
curl.exe -L -sS -o "%MODS_LIST%" "%MODS_LIST_URL%?t=%CACHE_BUST%" --max-time 60
if errorlevel 1 (
    echo [ERROR] No se pudo bajar la lista de mods.
    echo Verifica tu conexion a internet.
    pause
    exit /b 1
)
if not exist "%MODS_LIST%" (
    echo [ERROR] No se creo el archivo de lista.
    pause
    exit /b 1
)
echo [OK] Lista descargada.
echo.

REM --- Determinar carpeta destino ---
set "MODS_DEST="
if exist "%APPDATA%\.minecraft\mods" set "MODS_DEST=%APPDATA%\.minecraft\mods"
if not defined MODS_DEST if exist "%APPDATA%\.minecraft" set "MODS_DEST=%APPDATA%\.minecraft\mods"
if not defined MODS_DEST set "MODS_DEST=%LOCALAPPDATA%\TLauncher\mods"
if not exist "!MODS_DEST!" mkdir "!MODS_DEST!" 2>nul
echo Carpeta de mods: !MODS_DEST!
echo.

REM --- Bajar cada mod desde mods.csv ---
set "MOD_COUNT=0"
set "MODS_FAILED=0"

for /f "usebackq tokens=1,2 delims=," %%f in ("%MODS_LIST%") do (
    set "MOD_FILE=%%f"
    set "MOD_URL=%%g"
    if /i not "!MOD_FILE:~0,1!"=="#" (
        if defined MOD_FILE if defined MOD_URL (
            set /a MOD_COUNT+=1
            set "MOD_NUM=00!MOD_COUNT!"
            set "MOD_NUM=!MOD_NUM:~-3!"
            echo [!MOD_NUM!/31] !MOD_FILE!
            curl.exe -L -sS -o "!MODS_DEST!\!MOD_FILE!" "!MOD_URL!" --max-time 120
            if errorlevel 1 (
                echo        [FAIL]
                set /a MODS_FAILED+=1
            ) else (
                for %%S in ("!MODS_DEST!\!MOD_FILE!") do set "FILE_SIZE=%%~zS"
                echo        [OK] !FILE_SIZE! bytes
            )
        )
    )
)

del "%MODS_LIST%" 2>nul

echo ============================================
echo   Resumen: !MOD_COUNT! mods, !MODS_FAILED! fallaron
echo ============================================
if !MODS_FAILED! gtr 0 (
    echo.
    echo [!] Algunos mods no se pudieron descargar.
    echo     Vuelve a correr este script para reintentar.
)
echo.
echo Para jugar:
echo   1) Abre TLauncher
echo   2) Login con cualquier username (no-premium)
echo   3) Crea perfil: 1.21.1 + Fabric 0.16.5
echo   4) Conectate a: %SERVER%
echo.
pause
exit /b 0
