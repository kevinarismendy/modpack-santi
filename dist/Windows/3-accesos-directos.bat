@echo off
setlocal EnableExtensions EnableDelayedExpansion
title [3/3] Accesos Directos

echo ============================================
echo   [3/3] Creador de Accesos Directos
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
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.minecraft\TLauncher.exe" (
    set "TLAUNCHER_EXE=%APPDATA%\.minecraft\TLauncher.exe"
    set "TLAUNCHER_DIR=%APPDATA%\.minecraft\"
)
if not defined TLAUNCHER_EXE if exist "%APPDATA%\.minecraft\tlauncher.exe" (
    set "TLAUNCHER_EXE=%APPDATA%\.minecraft\tlauncher.exe"
    set "TLAUNCHER_DIR=%APPDATA%\.minecraft\"
)

if not defined TLAUNCHER_EXE (
    echo [ERROR] TLauncher no esta instalado.
    echo Primero corre "1-instalar-tlauncher.bat"
    pause
    exit /b 1
)

echo TLauncher: !TLAUNCHER_EXE!
echo.
echo Creando accesos directos en el escritorio...

REM --- Crear archivo VBS temporal para crear los shortcuts ---
set "VBS_FILE=%TEMP%\create_shortcuts_%RANDOM%.vbs"
(
    echo Set ws = CreateObject("WScript.Shell"^)
    echo Set desktop = ws.SpecialFolders("Desktop"^)
    echo.
    echo Set lnk1 = ws.CreateShortcut(desktop ^& "\Servidor Amiguos - TLauncher.lnk"^)
    echo lnk1.TargetPath = "!TLAUNCHER_EXE!"
    echo lnk1.WorkingDirectory = "!TLAUNCHER_DIR!"
    echo lnk1.Save
    echo.
    echo Set lnk2 = ws.CreateShortcut(desktop ^& "\Servidor Amiguos - Actualizar.lnk"^)
    echo lnk2.TargetPath = "%~dp02-instalar-mods.bat"
    echo lnk2.WorkingDirectory = "%~dp0"
    echo lnk2.IconLocation = "!TLAUNCHER_EXE!"
    echo lnk2.Save
) > "%VBS_FILE%"

cscript //nologo "%VBS_FILE%"
set VBS_RC=%errorlevel%
del "%VBS_FILE%" 2>nul

if %VBS_RC% neq 0 (
    echo [ERROR] No se pudieron crear los accesos directos.
) else (
    echo [OK] Accesos directos creados en el escritorio.
)
echo.
pause
exit /b 0
