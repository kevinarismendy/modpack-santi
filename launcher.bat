@echo off
chcp 65001 >nul
setlocal EnableExtensions
title Servidor Amiguos - Launcher
cd /d "%~dp0"

set "REPO=https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main"

echo ============================================
echo   Servidor Amiguos - Launcher
echo ============================================
echo.

REM --- Self-update: descargar la ultima version del launcher desde GitHub ---
echo [1/3] Verificando actualizaciones del launcher...
set "TEMP_LAUNCHER=%TEMP%\servidor_amigos_launcher_%random%.bat"
curl.exe -L -sS -o "%TEMP_LAUNCHER%" "%REPO%/launcher.bat" 2>nul
if exist "%TEMP_LAUNCHER%" (
    fc /b "%~f0" "%TEMP_LAUNCHER%" >nul 2>&1
    if errorlevel 1 (
        echo       Launcher actualizado. Reiniciando...
        copy /y "%TEMP_LAUNCHER%" "%~f0" >nul
        del "%TEMP_LAUNCHER%" 2>nul
        call "%~f0"
        exit /b %errorlevel%
    ) else (
        echo       Launcher al dia.
    )
    del "%TEMP_LAUNCHER%" 2>nul
) else (
    echo       [WARN] No se pudo verificar actualizaciones.
)

REM --- Descargar el instalador ---
echo [2/3] Descargando instalador...
set "TEMP_INSTALLER=%TEMP%\servidor_amigos_installer_%random%.bat"
curl.exe -L -sS -o "%TEMP_INSTALLER%" "%REPO%/install.bat"
if errorlevel 1 (
    echo [ERROR] No se pudo descargar el instalador.
    echo Verifica tu conexion a internet.
    pause
    exit /b 1
)
call "%TEMP_INSTALLER%"
exit /b %errorlevel%
