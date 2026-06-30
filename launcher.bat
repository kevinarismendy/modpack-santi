@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
title Servidor Amiguos - Launcher
cd /d "%~dp0"

set LAUNCHER_VERSION=1.5.0
set REPO=https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main

echo ============================================
echo   Servidor Amiguos - Launcher v%LAUNCHER_VERSION%
echo ============================================
echo.

REM --- [1/3] Self-update por version ---
echo [1/3] Verificando actualizaciones del launcher...
set "TEMP_LAUNCHER=%TEMP%\santicraft_launcher_%RANDOM%.bat"
curl.exe -L -sS -o "%TEMP_LAUNCHER%" "%REPO%/launcher.bat" 2>nul
set "REMOTE_VERSION="
if exist "%TEMP_LAUNCHER%" (
    for /f "tokens=2 delims==" %%v in ('findstr /b "set LAUNCHER_VERSION=" "%TEMP_LAUNCHER%" 2^>nul') do (
        set "REMOTE_VERSION=%%v"
    )
    if defined REMOTE_VERSION (
        if "!REMOTE_VERSION!" neq "%LAUNCHER_VERSION%" (
            echo       Version local: v%LAUNCHER_VERSION% ^| remota: v!REMOTE_VERSION!
            echo       Actualizando launcher...
            copy /y "%TEMP_LAUNCHER%" "%~f0" >nul 2>&1
            del "%TEMP_LAUNCHER%" 2>nul
            echo       Reiniciando con la nueva version...
            "%~f0"
            exit /b 0
        ) else (
            echo       Launcher al dia (v%LAUNCHER_VERSION%^).
        )
    ) else (
        echo       [WARN] No se pudo leer version remota.
    )
    del "%TEMP_LAUNCHER%" 2>nul
) else (
    echo       [WARN] No se pudo conectar a GitHub.
)

REM --- [2/3] Descargar instalador ---
echo [2/3] Descargando instalador...
set "TEMP_INSTALLER=%TEMP%\santicraft_installer_%RANDOM%.bat"
curl.exe -L -sS -o "%TEMP_INSTALLER%" "%REPO%/install.bat"
if !errorlevel! neq 0 (
    echo.
    echo [ERROR] No se pudo descargar el instalador.
    echo Verifica tu conexion a internet.
    echo Si el problema persiste, descarga el ZIP manualmente desde:
    echo   https://github.com/kevinarismendy/modpack-santi/releases/latest
    echo.
    echo Presiona cualquier tecla para cerrar...
    pause >nul
    exit /b 1
)

REM --- [3/3] Ejecutar instalador ---
echo [3/3] Ejecutando instalador...
echo.
call "%TEMP_INSTALLER%"
set "RC=!errorlevel!"
del "%TEMP_INSTALLER%" 2>nul

echo.
echo ============================================
if !RC! neq 0 (
    echo   El instalador termino con errores.
    echo   Revisa los mensajes arriba.
    echo   Si necesitas ayuda, contacta al admin del server.
) else (
    echo   Todo listo. Podes cerrar esta ventana.
    echo   Tu acceso directo a PrismLauncher esta en el escritorio.
)
echo ============================================
echo.
echo ==========================================
echo   >>>>>>  Presiona ENTER para cerrar  <<<<<<
echo ==========================================
pause
exit /b !RC!
