@echo off
setlocal EnableExtensions EnableDelayedExpansion
title [1/3] Instalar TLauncher

echo ============================================
echo   [1/3] Instalador de TLauncher
echo ============================================
echo.

set "TLAUNCHER_EXE="
set "TLAUNCHER_DIR="

if exist "%APPDATA%\.tlauncher\tlauncher.exe" (
    set "TLAUNCHER_EXE=%APPDATA%\.tlauncher\tlauncher.exe"
    set "TLAUNCHER_DIR=%APPDATA%\.tlauncher\"
)
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.tlauncher\TLauncher.exe" (
    set "TLAUNCHER_EXE=%APPDATA%\.tlauncher\TLauncher.exe"
    set "TLAUNCHER_DIR=%APPDATA%\.tlauncher\"
)
if not defined TLAUNCHER_EXE if exist "%LOCALAPPDATA%\TLauncher\tlauncher.exe" (
    set "TLAUNCHER_EXE=%LOCALAPPDATA%\TLauncher\tlauncher.exe"
    set "TLAUNCHER_DIR=%LOCALAPPDATA%\TLauncher\"
)
if not defined TLAUNCHER_EXE if exist "%LOCALAPPDATA%\TLauncher\TLauncher.exe" (
    set "TLAUNCHER_EXE=%LOCALAPPDATA%\TLauncher\TLauncher.exe"
    set "TLAUNCHER_DIR=%LOCALAPPDATA%\TLauncher\"
)
if not defined TLAUNCHER_EXE if exist "C:\Program Files\TLauncher\tlauncher.exe" (
    set "TLAUNCHER_EXE=C:\Program Files\TLauncher\tlauncher.exe"
    set "TLAUNCHER_DIR=C:\Program Files\TLauncher\"
)
if not defined TLAUNCHER_EXE if exist "C:\Program Files\TLauncher\TLauncher.exe" (
    set "TLAUNCHER_EXE=C:\Program Files\TLauncher\TLauncher.exe"
    set "TLAUNCHER_DIR=C:\Program Files\TLauncher\"
)
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.minecraft\TLauncher.exe" (
    set "TLAUNCHER_EXE=%APPDATA%\.minecraft\TLauncher.exe"
    set "TLAUNCHER_DIR=%APPDATA%\.minecraft\"
)
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.minecraft\tlauncher.exe" (
    set "TLAUNCHER_EXE=%APPDATA%\.minecraft\tlauncher.exe"
    set "TLAUNCHER_DIR=%APPDATA%\.minecraft\"
)

if defined TLAUNCHER_EXE (
    echo [OK] TLauncher ya esta instalado: !TLAUNCHER_EXE!
    echo.
    echo Si queres reinstalarlo, borra esa carpeta y volve a correr.
    pause
    exit /b 0
)

set "TLAUNCHER_URL=https://github.com/kevinarismendy/modpack-santi/releases/download/tlauncher-v1/TLauncher-Setup.exe"
set "TLAUNCHER_SETUP=%TEMP%\TLauncher-Setup.exe"

echo [!] TLauncher no encontrado. Descargando instalador (~26 MB)...
curl.exe -L -o "%TLAUNCHER_SETUP%" "%TLAUNCHER_URL%" --max-time 180
if errorlevel 1 (
    echo [ERROR] No se pudo descargar TLauncher.
    pause
    exit /b 1
)

echo.
echo [i] Ejecutando instalador. Sigue las instrucciones en pantalla.
start "" "%TLAUNCHER_SETUP%"
echo Cuando termine la instalacion, vuelve aca y presiona ENTER.
pause
del "%TLAUNCHER_SETUP%" 2>nul

REM Re-detectar
set "TLAUNCHER_EXE="
set "TLAUNCHER_DIR="
if exist "%APPDATA%\.tlauncher\tlauncher.exe" (
    set "TLAUNCHER_EXE=%APPDATA%\.tlauncher\tlauncher.exe"
    set "TLAUNCHER_DIR=%APPDATA%\.tlauncher\"
)
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.tlauncher\TLauncher.exe" (
    set "TLAUNCHER_EXE=%APPDATA%\.tlauncher\TLauncher.exe"
    set "TLAUNCHER_DIR=%APPDATA%\.tlauncher\"
)
if not defined TLAUNCHER_EXE if exist "%LOCALAPPDATA%\TLauncher\tlauncher.exe" (
    set "TLAUNCHER_EXE=%LOCALAPPDATA%\TLauncher\tlauncher.exe"
    set "TLAUNCHER_DIR=%LOCALAPPDATA%\TLauncher\"
)
if not defined TLAUNCHER_EXE if exist "%LOCALAPPDATA%\TLauncher\TLauncher.exe" (
    set "TLAUNCHER_EXE=%LOCALAPPDATA%\TLauncher\TLauncher.exe"
    set "TLAUNCHER_DIR=%LOCALAPPDATA%\TLauncher\"
)
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.minecraft\TLauncher.exe" (
    set "TLAUNCHER_EXE=%APPDATA%\.minecraft\TLauncher.exe"
    set "TLAUNCHER_DIR=%APPDATA%\.minecraft\"
)
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.minecraft\tlauncher.exe" (
    set "TLAUNCHER_EXE=%APPDATA%\.minecraft\tlauncher.exe"
    set "TLAUNCHER_DIR=%APPDATA%\.minecraft\"
)

if defined TLAUNCHER_EXE (
    echo.
    echo [OK] TLauncher instalado: !TLAUNCHER_EXE!
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
