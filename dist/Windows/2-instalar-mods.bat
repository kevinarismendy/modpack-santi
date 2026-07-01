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
set "INSTANCE=Servidor Amiguos"
set "SERVER_IP=135.148.137.58:19403"

echo ============================================
echo   [2/3] Instalador de Mods
echo   MC 1.21.1 + Fabric 0.19.3
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
echo Descargando 34 mods Fabric desde GitHub (cache-bust)...
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

REM --- Copiar mods a la instancia aislada versions\Servidor Amiguos\mods ---
set "INSTANCE_DIR=%APPDATA%\.minecraft\versions\%INSTANCE%"
set "MODS_DEST=%INSTANCE_DIR%\mods"
if not exist "!MODS_DEST!" mkdir "!MODS_DEST!" 2>nul
echo.
echo Copiando mods a !MODS_DEST! ...
xcopy /E /Y /Q "!MODS_SOURCE!\*" "!MODS_DEST!\" >nul 2>&1
rmdir /s /q "!MODS_TEMP!" 2>nul
echo [OK] Mods instalados en la instancia "%INSTANCE%".
echo.

REM --- Escribir servers.dat con el server preconfigurado (solo si no existe) ---
echo Configurando servidor %SERVER_IP% ...
if exist "!INSTANCE_DIR!\servers.dat" (
    echo [OK] servers.dat ya existe, no se sobrescribe.
    goto :after_servers
)
set "SRV_PS=%TEMP%\gen_servers_%RANDOM%.ps1"
> "%SRV_PS%" echo $ip = '%SERVER_IP%'
>> "%SRV_PS%" echo $name = '%INSTANCE%'
>> "%SRV_PS%" echo $ms = New-Object System.IO.MemoryStream
>> "%SRV_PS%" echo function W($b){ $y=[byte[]]$b; $ms.Write($y,0,$y.Length) }
>> "%SRV_PS%" echo function WStr($s){ $x=[Text.Encoding]::UTF8.GetBytes($s); W @([byte](($x.Length -shr 8) -band 0xFF),[byte]($x.Length -band 0xFF)); W $x }
>> "%SRV_PS%" echo W @([byte]0x0A,[byte]0x00,[byte]0x00)
>> "%SRV_PS%" echo W @([byte]0x09); WStr 'servers'; W @([byte]0x0A,[byte]0x00,[byte]0x00,[byte]0x00,[byte]0x01)
>> "%SRV_PS%" echo W @([byte]0x08); WStr 'ip'; WStr $ip
>> "%SRV_PS%" echo W @([byte]0x08); WStr 'name'; WStr $name
>> "%SRV_PS%" echo W @([byte]0x01); WStr 'hidden'; W @([byte]0x00)
>> "%SRV_PS%" echo W @([byte]0x00,[byte]0x00)
>> "%SRV_PS%" echo [IO.File]::WriteAllBytes((Join-Path '!INSTANCE_DIR!' 'servers.dat'), $ms.ToArray())
powershell -NoProfile -ExecutionPolicy Bypass -File "%SRV_PS%" >nul 2>&1
del "%SRV_PS%" 2>nul
if exist "!INSTANCE_DIR!\servers.dat" (
    echo [OK] Servidor agregado: %SERVER_IP%
) else (
    echo [!] No se pudo escribir servers.dat. Agrega el server manualmente.
)
:after_servers
echo.

echo ============================================
echo   Listo. Ya podes jugar.
echo.
echo   Los mods se copiaron a: !MODS_DEST!
echo.
echo   1) Abre TLauncher
echo   2) Login con cualquier username (no-premium)
echo   3) Crea/selecciona una version Fabric 1.21.1 (Loader 0.19.3+)
echo      y nombrala EXACTAMENTE:  %INSTANCE%
echo      (con "carpetas separadas por version" activado)
echo   4) El servidor %SERVER_IP% ya aparece en la lista
echo ============================================
echo.
echo Presiona una tecla para cerrar (o espera 60 segundos)...
timeout /t 60 /nobreak >nul 2>&1
exit /b 0
