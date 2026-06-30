@echo off
title [1/3] Instalar TLauncher
setlocal

echo ============================================
echo   [1/3] Instalador de TLauncher
echo ============================================
echo.

set "TLAUNCHER_URL=https://github.com/kevinarismendy/modpack-santi/releases/download/tlauncher-v1/TLauncher-Setup.exe"
set "TLAUNCHER_SETUP=%TEMP%\TLauncher-Setup.exe"
set "TLAUNCHER_EXE="
set "TLAUNCHER_DIR="

REM --- Detectar TLauncher existente ---
call :find_tlauncher
if defined TLAUNCHER_EXE (
    echo [OK] TLauncher ya esta instalado: !TLAUNCHER_EXE!
    echo.
    echo Si queres reinstalarlo, borra esa carpeta y volve a correr.
    pause
    exit /b 0
)

echo [!] TLauncher no encontrado. Descargando instalador (~26 MB)...
curl.exe -L -o "%TLAUNCHER_SETUP%" "%TLAUNCHER_URL%" --max-time 180
if errorlevel 1 (
    echo [ERROR] No se pudo descargar TLauncher.
    echo Verifica tu conexion a internet.
    pause
    exit /b 1
)

echo [i] Ejecutando instalador. Sigue las instrucciones en pantalla.
echo.
start "" "%TLAUNCHER_SETUP%"
echo Cuando termine la instalacion, vuelve aca y presiona ENTER.
pause

del "%TLAUNCHER_SETUP%" 2>nul

call :find_tlauncher
if defined TLAUNCHER_EXE (
    echo.
    echo [OK] TLauncher instalado: !TLAUNCHER_EXE!
    echo.
    echo Siguiente paso: corre "2-instalar-mods.bat"
) else (
    echo.
    echo [!] No se detecta TLauncher aun. Si lo instalaste correctamente,
    echo     verifica que este en una de estas carpetas:
    echo       %%APPDATA%%\.tlauncher\
    echo       %%LOCALAPPDATA%%\TLauncher\
    echo       C:\Program Files\TLauncher\
    echo       %%APPDATA%%\.minecraft\
)
echo.
pause
exit /b 0

:find_tlauncher
if exist "%APPDATA%\.tlauncher\tlauncher.exe" (set "TLAUNCHER_EXE=%APPDATA%\.tlauncher\tlauncher.exe") & (set "TLAUNCHER_DIR=%APPDATA%\.tlauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%APPDATA%\.tlauncher\TLauncher.exe" (set "TLAUNCHER_EXE=%APPDATA%\.tlauncher\TLauncher.exe") & (set "TLAUNCHER_DIR=%APPDATA%\.tlauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%LOCALAPPDATA%\TLauncher\tlauncher.exe" (set "TLAUNCHER_EXE=%LOCALAPPDATA%\TLauncher\tlauncher.exe") & (set "TLAUNCHER_DIR=%LOCALAPPDATA%\TLauncher\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%LOCALAPPDATA%\TLauncher\TLauncher.exe" (set "TLAUNCHER_EXE=%LOCALAPPDATA%\TLauncher\TLauncher.exe") & (set "TLAUNCHER_DIR=%LOCALAPPDATA%\TLauncher\")
if exist "%APPDATA%\.minecraft\TLauncher.exe" (set "TLAUNCHER_EXE=%APPDATA%\.minecraft\TLauncher.exe") & (set "TLAUNCHER_DIR=%APPDATA%\.minecraft\")
if defined TLAUNCHER_EXE exit /b 0
if exist "%APPDATA%\.minecraft\tlauncher.exe" (set "TLAUNCHER_EXE=%APPDATA%\.minecraft\tlauncher.exe") & (set "TLAUNCHER_DIR=%APPDATA%\.minecraft\")
exit /b 0
