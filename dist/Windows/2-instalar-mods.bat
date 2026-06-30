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

REM --- Detectar Java 21+ (opcional, solo para instalar JDK portable) ---
where java >nul 2>&1
if errorlevel 1 (
    if not exist "%JDK_DIR%\bin\java.exe" (
        echo [!] Java 21+ no encontrado. Bajando JDK 21 portable...
        set "JDK_ZIP=%TEMP%\servidor_amigos_jdk.zip"
        set "JDK_URL=https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jdk/hotspot/normal/eclipse"
        curl.exe -L -sS -o "%JDK_ZIP%" "%JDK_URL%"
        if errorlevel 1 (
            echo [WARN] No se pudo bajar JDK. Si tienes Java 21+ instalado, ignora este mensaje.
        ) else (
            if exist "%JDK_DIR%" rmdir /s /q "%JDK_DIR%" 2>nul
            if exist "%EXTRACT_DIR%" rmdir /s /q "%EXTRACT_DIR%" 2>nul
            mkdir "%EXTRACT_DIR%" 2>nul
            powershell -NoProfile -Command "Expand-Archive -LiteralPath '%JDK_ZIP%' -DestinationPath '%EXTRACT_DIR%' -Force" >nul 2>&1
            del "%JDK_ZIP%" 2>nul
            for /d %%D in ("%EXTRACT_DIR%\*") do (
                if exist "%%D\bin\java.exe" robocopy "%%D" "%JDK_DIR%" /E /MOVE /NFL /NDL /NJH /NJS /NC /NS >nul 2>&1
            )
            rmdir "%EXTRACT_DIR%" 2>nul
            if exist "%JDK_DIR%\bin\java.exe" (
                echo [OK] JDK 21 en %JDK_DIR%
            ) else (
                echo [WARN] No se encontro java.exe despues de extraer.
            )
        )
    )
)
echo.

REM --- Bajar lista de mods (mods.csv) ---
set "MODS_LIST=%TEMP%\servidor-amiguos-mods-%RANDOM%.csv"
echo Descargando lista de mods...
curl.exe -L -sS -o "%MODS_LIST%" "%MODS_LIST_URL%" --max-time 60
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
REM Formato CSV: filename,url
set "MOD_COUNT=0"
set "MODS_FAILED=0"
set "TOTAL_BYTES=0"

for /f "usebackq tokens=1,2 delims=," %%f in ("%MODS_LIST%") do (
    set "MOD_FILE=%%f"
    set "MOD_URL=%%g"
    if /i not "!MOD_FILE:~0,1!"=="#" (
        if defined MOD_FILE if defined MOD_URL (
            set /a MOD_COUNT+=1
            set "MOD_NUM=00!MOD_COUNT!"
            set "MOD_NUM=!MOD_NUM:~-3!"
            echo [!MOD_NUM!/??] !MOD_FILE!
            curl.exe -L -sS -o "!MODS_DEST!\!MOD_FILE!" "!MOD_URL!" --max-time 120
            if errorlevel 1 (
                echo        [FAIL]
                set /a MODS_FAILED+=1
            ) else (
                for %%S in ("!MODS_DEST!\!MOD_FILE!") do set "FILE_SIZE=%%~zS"
                echo        [OK] !FILE_SIZE! bytes
                set /a TOTAL_BYTES+=FILE_SIZE
            )
        )
    )
)

del "%MODS_LIST%" 2>nul

echo.
echo ============================================
echo   Resumen: !MOD_COUNT! mods, !MODS_FAILED! fallaron
echo ============================================
echo.
echo Para jugar:
echo   1) Abre TLauncher
echo   2) Login con cualquier username (no-premium)
echo   3) Crea perfil: 1.21.1 + Fabric 0.16.5
echo   4) Conectate a: %SERVER%
echo.
pause
exit /b 0
