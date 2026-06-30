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
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ws = New-Object -ComObject WScript.Shell; ^
     $sc = $ws.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\Servidor Amiguos - TLauncher.lnk'); ^
     $sc.TargetPath = '%TLAUNCHER_EXE%'; ^
     $sc.WorkingDirectory = '%TLAUNCHER_DIR%'; ^
     $sc.Save(); ^
     $su = $ws.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\Servidor Amiguos - Actualizar.bat.lnk'); ^
     $su.TargetPath = '%~dp02-instalar-mods.bat'; ^
     $su.WorkingDirectory = '%~dp0'; ^
     $su.IconLocation = '%TLAUNCHER_EXE%'; ^
     $su.Save()"
if errorlevel 1 (
    echo [ERROR] No se pudieron crear los accesos directos.
) else (
    echo [OK] Accesos directos creados en el escritorio.
)
echo.
pause
exit /b 0
