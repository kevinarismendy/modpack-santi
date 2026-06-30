@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
title Servidor Amiguos - Modpack Installer
cd /d "%~dp0"

REM --- Auto-elevar a admin (necesario para instalar TLauncher) ---
net session >nul 2>&1
if errorlevel 1 (
    echo [Setup] Re-ejecutando como Administrador (UAC)...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WorkingDirectory '%~dp0'"
    exit /b
)

set MIN_JAVA=21
set JDK_DIR=%LOCALAPPDATA%\jdk21
set EXTRACT_DIR=%LOCALAPPDATA%\jdk_extract_temp
set BOOTSTRAP_URL=https://cdn.jsdelivr.net/gh/kevinarismendy/modpack-santi@main/pack.toml
set BOOTSTRAP_JAR=packwiz-installer-bootstrap.jar
set LAUNCHER_URL=https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main/dist/launcher.bat
set TLAUNCHER_URL=https://github.com/kevinarismendy/modpack-santi/releases/download/tlauncher-v1/TLauncher-Setup.exe
set SERVER=amiguos.holy.gg
set INSTANCE_NAME=Servidor Amiguos
set TLAUNCHER_EXE=

echo ============================================
echo   Servidor Amiguos - Modpack Installer
echo   MC 1.21.1 + Fabric 0.16.5
echo ============================================
echo.

REM --- [Pre] Auto-actualizar el launcher para la proxima corrida ---
echo [Pre] Verificando actualizaciones del launcher...
set "TEMP_LAUNCHER=%TEMP%\santicraft_launcher_%RANDOM%.bat"
curl.exe -L -sS -o "%TEMP_LAUNCHER%" "%LAUNCHER_URL%" 2>nul
if exist "%TEMP_LAUNCHER%" (
    fc /b "%~dp0launcher.bat" "%TEMP_LAUNCHER%" >nul 2>nul
    if errorlevel 1 (
        echo       Launcher actualizado. La proxima corrida usara la version nueva.
        copy /y "%TEMP_LAUNCHER%" "%~dp0launcher.bat" >nul 2>nul
    ) else (
        echo       Launcher al dia.
    )
    del "%TEMP_LAUNCHER%" 2>nul
) else (
    echo       Launcher al dia.
)
echo.

REM --- Localizar TLauncher existente (15+ paths) ---
call :find_tlauncher
if defined TLAUNCHER_EXE (
    echo [1/5] [OK] TLauncher detectado: !TLAUNCHER_EXE!
) else (
    echo [1/5] [!] TLauncher no encontrado. Descargando...
    call :install_tlauncher
    if errorlevel 1 (
        echo       [ERROR] No se pudo instalar TLauncher. Bajalo de https://tlauncher.org/en/ y volve a correr.
        pause
        exit /b 1
    )
    call :find_tlauncher
    if not defined TLAUNCHER_EXE (
        echo       [ERROR] TLauncher instalado pero no detectado.
        pause
        exit /b 1
    )
    echo       [OK] TLauncher instalado: !TLAUNCHER_EXE!
)
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
if defined JAVA_CMD (
    for /f "tokens=2 delims=" %%v in ('"java -version 2>&1" ^| findstr /i "version"') do echo [2/5] [OK] Java %%v detectado
) else (
    if exist "%JDK_DIR%\bin\java.exe" (
        echo [2/5] [OK] Usando JDK portable en %JDK_DIR%
        set "JAVA_CMD=%JDK_DIR%\bin\java.exe"
    ) else (
        echo [2/5] [!] Java %MIN_JAVA%+ no encontrado. Instalando portable...
        call :install_jdk_windows
        if errorlevel 1 (
            echo [ERROR] No se pudo instalar Java automaticamente.
            echo Descargalo manualmente desde https://adoptium.net/ y volve a correr.
            pause
            exit /b 1
        )
        set "JAVA_CMD=%JDK_DIR%\bin\java.exe"
    )
)
echo.

REM --- Descargar bootstrap si hace falta ---
if not exist %BOOTSTRAP_JAR% (
    echo [3/5] Descargando packwiz bootstrap...
    curl.exe -L -sS -o %BOOTSTRAP_JAR% "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
    if errorlevel 1 (
        echo [ERROR] No se pudo descargar el bootstrap.
        pause
        exit /b 1
    )
)
echo [3/5] [OK] Bootstrap listo
echo.

REM --- Crear/actualizar instancia de TLauncher ---
echo [4/5] Configurando instancia "%INSTANCE_NAME%" en TLauncher...
call :find_tlauncher_root
if defined TLAUNCHER_ROOT (
    set "INSTANCE=!TLAUNCHER_ROOT!\instances\%INSTANCE_NAME%"
    set "MODS_TEMP=%TEMP%\santicraft-mods-%RANDOM%"
    mkdir "!MODS_TEMP!" 2>nul
    echo       Bajando mods a !MODS_TEMP!\minecraft\mods ...
    pushd "!MODS_TEMP!"
    "!JAVA_CMD!" -jar "%~dp0%BOOTSTRAP_JAR%" -g %BOOTSTRAP_URL%
    set BOOTSTRAP_RC=!errorlevel!
    popd
    if !BOOTSTRAP_RC! neq 0 (
        echo       [WARN] Bootstrap fallo. Los mods se descargaran cuando abras TLauncher.
    ) else (
        if exist "!MODS_TEMP!\minecraft\mods" (
            if not exist "!INSTANCE!" mkdir "!INSTANCE!\.minecraft\mods" 2>nul
            if exist "!INSTANCE!\.minecraft\mods" (
                xcopy /E /Y /Q "!MODS_TEMP!\minecraft\mods\*" "!INSTANCE!\.minecraft\mods\" >nul 2>&1
            )
            if not exist "!INSTANCE!\instance.cfg" (
                (
                    echo InstanceType=OneSix
                    echo name=%INSTANCE_NAME%
                    echo iconKey=grass_block
                ) > "!INSTANCE!\instance.cfg"
            )
            copy /Y "%~dp0%BOOTSTRAP_JAR%" "!INSTANCE!\.minecraft\packwiz-installer-bootstrap.jar" >nul 2>&1
            echo       [OK] Instancia: !INSTANCE!
        ) else (
            echo       [WARN] No se encontraron mods descargados.
        )
    )
    rmdir /s /q "!MODS_TEMP!" 2>nul
) else (
    echo       [WARN] TLauncher no detectado, instancia no creada. Crealo manual en TLauncher.
)
echo.

REM --- Accesos directos ---
echo [5/5] Creando accesos directos en el escritorio...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ws = New-Object -ComObject WScript.Shell; ^
     $sc = $ws.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\Servidor Amiguos - TLauncher.lnk'); ^
     $sc.TargetPath = '%TLAUNCHER_EXE%'; ^
     $sc.WorkingDirectory = '%TLAUNCHER_DIR%'; ^
     $sc.Save(); ^
     $su = $ws.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\Servidor Amiguos - Actualizar.lnk'); ^
     $su.TargetPath = '%~dp0launcher.bat'; ^
     $su.WorkingDirectory = '%~dp0'; ^
     $su.IconLocation = '%TLAUNCHER_EXE%'; ^
     $su.Save()"
echo       [OK] Accesos directos creados
echo.

echo ============================================
echo   Listo. Ya podes jugar.
echo.
echo   1) Abre TLauncher desde el escritorio
echo   2) Login con cualquier username (no-premium)
echo   3) Selecciona la instancia "%INSTANCE_NAME%" (ya creada)
echo      Si no aparece: "+" o "Add Instance" -^> 1.21.1 + Fabric 0.16.5
echo   4) Conectate a: %SERVER%
echo ============================================
echo.
echo   Para actualizar mods: corre "Servidor Amiguos - Actualizar"
echo.
pause
exit /b 0

REM ========== Subrutinas ==========

:find_tlauncher
set "TLAUNCHER_EXE="
set "TLAUNCHER_DIR="
set "CANDIDATE="
if exist "%APPDATA%\.tlauncher\tlauncher.exe" (set "TLAUNCHER_EXE=%APPDATA%\.tlauncher\tlauncher.exe") & (set "TLAUNCHER_DIR=%APPDATA%\.tlauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%APPDATA%\.tlauncher\TLauncher.exe" (set "TLAUNCHER_EXE=%APPDATA%\.tlauncher\TLauncher.exe") & (set "TLAUNCHER_DIR=%APPDATA%\.tlauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%LOCALAPPDATA%\Programs\TLauncher\tlauncher.exe" (set "TLAUNCHER_EXE=%LOCALAPPDATA%\Programs\TLauncher\tlauncher.exe") & (set "TLAUNCHER_DIR=%LOCALAPPDATA%\Programs\TLauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%LOCALAPPDATA%\Programs\TLauncher\TLauncher.exe" (set "TLAUNCHER_EXE=%LOCALAPPDATA%\Programs\TLauncher\TLauncher.exe") & (set "TLAUNCHER_DIR=%LOCALAPPDATA%\Programs\TLauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%LOCALAPPDATA%\TLauncher\tlauncher.exe" (set "TLAUNCHER_EXE=%LOCALAPPDATA%\TLauncher\tlauncher.exe") & (set "TLAUNCHER_DIR=%LOCALAPPDATA%\TLauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%LOCALAPPDATA%\TLauncher\TLauncher.exe" (set "TLAUNCHER_EXE=%LOCALAPPDATA%\TLauncher\TLauncher.exe") & (set "TLAUNCHER_DIR=%LOCALAPPDATA%\TLauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "C:\Program Files\TLauncher\tlauncher.exe" (set "TLAUNCHER_EXE=C:\Program Files\TLauncher\tlauncher.exe") & (set "TLAUNCHER_DIR=C:\Program Files\TLauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "C:\Program Files\TLauncher\TLauncher.exe" (set "TLAUNCHER_EXE=C:\Program Files\TLauncher\TLauncher.exe") & (set "TLAUNCHER_DIR=C:\Program Files\TLauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%APPDATA%\.minecraft\TLauncher.exe" (set "TLAUNCHER_EXE=%APPDATA%\.minecraft\TLauncher.exe") & (set "TLAUNCHER_DIR=%APPDATA%\.minecraft\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%APPDATA%\.minecraft\tlauncher.exe" (set "TLAUNCHER_EXE=%APPDATA%\.minecraft\tlauncher.exe") & (set "TLAUNCHER_DIR=%APPDATA%\.minecraft\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%APPDATA%\.minecraft\TLauncher32bit.exe" (set "TLAUNCHER_EXE=%APPDATA%\.minecraft\TLauncher32bit.exe") & (set "TLAUNCHER_DIR=%APPDATA%\.minecraft\")
if defined TLAUNCHER_EXE exit /b 0
if exist "C:\TLauncher\tlauncher.exe" (set "TLAUNCHER_EXE=C:\TLauncher\tlauncher.exe") & (set "TLAUNCHER_DIR=C:\TLauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "C:\TLauncher\TLauncher.exe" (set "TLAUNCHER_EXE=C:\TLauncher\TLauncher.exe") & (set "TLAUNCHER_DIR=C:\TLauncher\")
exit /b 0

:find_tlauncher_root
set "TLAUNCHER_ROOT="
if exist "%APPDATA%\.tlauncher" set "TLAUNCHER_ROOT=%APPDATA%\.tlauncher"
if exist "%LOCALAPPDATA%\Programs\TLauncher" if not defined TLAUNCHER_ROOT set "TLAUNCHER_ROOT=%LOCALAPPDATA%\Programs\TLauncher"
if exist "%LOCALAPPDATA%\TLauncher" if not defined TLAUNCHER_ROOT set "TLAUNCHER_ROOT=%LOCALAPPDATA%\TLauncher"
if not defined TLAUNCHER_ROOT if exist "%APPDATA%\.minecraft\TLauncher.exe" set "TLAUNCHER_ROOT=%APPDATA%\.minecraft"
if not defined TLAUNCHER_ROOT if exist "%APPDATA%\.minecraft\tlauncher.exe" set "TLAUNCHER_ROOT=%APPDATA%\.minecraft"
exit /b 0

:install_tlauncher
set "TLAUNCHER_SETUP=%TEMP%\TLauncher-Setup.exe"
echo       Descargando TLauncher (~26 MB)...
curl.exe -L -o "%TLAUNCHER_SETUP%" "%TLAUNCHER_URL%" --max-time 180
if errorlevel 1 exit /b 1
echo       Ejecutando instalador silencioso (1-2 min)...
REM Usar PowerShell Start-Process -Wait para evitar que el instalador cierre nuestra consola
powershell -NoProfile -Command "Start-Process -FilePath '%TLAUNCHER_SETUP%' -ArgumentList '/S' -Wait -NoNewWindow"
set "PS_RC=%errorlevel%"
del "%TLAUNCHER_SETUP%" 2>nul
if not "%PS_RC%"=="0" exit /b 1
exit /b 0

:install_jdk_windows
set "JDK_ZIP=%TEMP%\servidor_amigos_jdk.zip"
set "JDK_URL=https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jdk/hotspot/normal/eclipse"
echo Descargando JDK 21 (portable) desde Adoptium...
curl.exe -L -sS -o "%JDK_ZIP%" "%JDK_URL%"
if errorlevel 1 exit /b 1
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
if not exist "%JDK_DIR%\bin\java.exe" exit /b 1
echo [OK] JDK 21 instalado en %JDK_DIR%
exit /b 0
