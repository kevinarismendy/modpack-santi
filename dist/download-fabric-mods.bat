@echo off
REM ============================================================
REM  Descarga los 39 mods Fabric directamente a la carpeta del server
REM  Uso: ejecutar desde donde esté el script
REM ============================================================

setlocal EnableExtensions EnableDelayedExpansion

set "SERVER_MODS=C:\Users\kevin\OneDrive\Desktop\Modpack_Santi_Server\mods"
set "BOOTSTRAP_URL=https://cdn.jsdelivr.net/gh/kevinarismendy/modpack-santi@main/pack.toml"
set "TMPDIR=%TEMP%\fabric_mods_%RANDOM%"

if not exist "%SERVER_MODS%" mkdir "%SERVER_MODS%"

echo Descargando mods via packwiz-installer-bootstrap...
echo Destino: %SERVER_MODS%
echo.

REM 1. Bajar packwiz-installer-bootstrap.jar
set "BOOTSTRAP_JAR=%TMPDIR%\packwiz-installer-bootstrap.jar"
mkdir "%TMPDIR%"
curl.exe -L -o "%BOOTSTRAP_JAR%" "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar" --max-time 60
if errorlevel 1 (
    echo [ERROR] No se pudo bajar el bootstrap.
    pause
    exit /b 1
)

REM 2. Correr el bootstrap que descarga a minecraft/mods/
echo Corriendo bootstrap para descargar mods a %TMPDIR%\minecraft\mods ...
cd /d "%TMPDIR%"
java -jar "%BOOTSTRAP_JAR%" -g "%BOOTSTRAP_URL%"
if errorlevel 1 (
    echo [ERROR] El bootstrap fallo.
    cd /d "%USERPROFILE%"
    pause
    exit /b 1
)

REM 3. Copiar mods de la carpeta temporal a la carpeta del server
if exist "%TMPDIR%\minecraft\mods\*.jar" (
    echo.
    echo Copiando mods a %SERVER_MODS% ...
    xcopy /Y /Q "%TMPDIR%\minecraft\mods\*.jar" "%SERVER_MODS%\" >nul
    echo.
    echo [OK] %SERVER_MODS% poblado
) else (
    echo [ERROR] No se encontraron mods descargados.
    cd /d "%USERPROFILE%"
    pause
    exit /b 1
)

REM 4. Cleanup
cd /d "%USERPROFILE%"
rmdir /s /q "%TMPDIR%" 2>nul

echo.
echo ============================================
echo  Listo. %SERVER_MODS% poblado con mods Fabric.
echo ============================================
echo.
echo Siguiente paso: sube esta carpeta a tu servidor HolyHosting.
echo.
pause
exit /b 0
