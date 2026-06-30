@echo off
chcp 65001 >nul
setlocal EnableExtensions
title Servidor Amiguos - Launcher
cd /d "%~dp0"

echo ============================================
echo   Servidor Amiguos - Launcher
echo ============================================
echo.
echo Descargando ultima version del instalador...
curl.exe -L -sS -o "%TEMP%\servidor_amigos_install.bat" "https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main/install.bat"
if errorlevel 1 (
    echo [ERROR] No se pudo descargar el instalador.
    echo Verifica tu conexion a internet.
    pause
    exit /b 1
)
call "%TEMP%\servidor_amigos_install.bat"
exit /b %errorlevel%
