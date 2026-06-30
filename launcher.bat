@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
title Servidor Amiguos - Launcher
cd /d "%~dp0"

set LAUNCHER_VERSION=1.5.2
set REPO=https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main

echo ============================================
echo   Servidor Amiguos - Launcher v%LAUNCHER_VERSION%
echo ============================================
echo.

REM --- [1/3] Self-update (omitir si ya se actualizo en esta sesion) ---
if /i "%~1"=="skip" (
    echo [1/3] Launcher v%LAUNCHER_VERSION% cargado. Continuando...
) else (
    echo [1/3] Verificando actualizaciones del launcher...
    set "TEMP_VERSION=%TEMP%\santicraft_version_%RANDOM%.txt"
    set "REMOTE_VERSION="
    curl.exe -L -sS -o "%TEMP_VERSION%" "%REPO%/version.txt" 2>nul
    if exist "%TEMP_VERSION%" (
        for /f "usebackq tokens=*" %%v in ("%TEMP_VERSION%") do (
            set "REMOTE_VERSION=%%v"
        )
        del "%TEMP_VERSION%" 2>nul
    )
    if defined REMOTE_VERSION (
        if /i not "!REMOTE_VERSION!"=="%LAUNCHER_VERSION%" (
            echo       Local: v%LAUNCHER_VERSION% ^| Remota: v!REMOTE_VERSION!
            echo       Actualizando launcher...
            set "TEMP_NEW=%TEMP%\santicraft_launcher_%RANDOM%.bat"
            curl.exe -L -sS -o "%TEMP_NEW%" "%REPO%/launcher.bat" 2>nul
            if exist "%TEMP_NEW%" (
                copy /y "%TEMP_NEW%" "%~f0" >nul
                del "%TEMP_NEW%" 2>nul
                echo       Reiniciando con la nueva version...
                "%~f0" skip
                exit /b 0
            ) else (
                echo       [WARN] No se pudo descargar el nuevo launcher.
            )
        ) else (
            echo       Launcher al dia (v%LAUNCHER_VERSION%^).
        )
    ) else (
        echo       [WARN] No se pudo leer la version remota. Continuando con v%LAUNCHER_VERSION%.
    )
)

REM --- [2/3] Descargar y ejecutar instalador ---
echo [2/3] Descargando instalador...
set "TEMP_INSTALLER=%TEMP%\santicraft_installer_%RANDOM%.bat"
curl.exe -L -sS -o "%TEMP_INSTALLER%" "%REPO%/install.bat"
if !errorlevel! neq 0 (
    echo.
    echo [ERROR] No se pudo descargar el instalador.
    echo Descargalo manualmente desde:
    echo   https://github.com/kevinarismendy/modpack-santi/releases/latest
    echo.
    pause
    exit /b 1
)

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
) else (
    echo   Todo listo. Tu acceso directo a PrismLauncher esta en el escritorio.
)
echo ============================================
echo.
echo ==========================================
echo   >>>>>>  Presiona ENTER para cerrar  <<<<<<
echo ==========================================
pause
exit /b !RC!
