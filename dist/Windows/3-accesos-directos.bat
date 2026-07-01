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

REM --- Write PowerShell script to a temp .ps1 file (avoids all escaping issues) ---
set "PS_SCRIPT=%TEMP%\create_shortcuts_%RANDOM%.ps1"
> "%PS_SCRIPT%" echo $ws = New-Object -ComObject WScript.Shell
>> "%PS_SCRIPT%" echo $d = [Environment]::GetFolderPath('Desktop')
>> "%PS_SCRIPT%" echo $l1 = $ws.CreateShortcut((Join-Path $d 'Servidor Amiguos - TLauncher.lnk'))
>> "%PS_SCRIPT%" echo $l1.TargetPath = '!TLAUNCHER_EXE!'
>> "%PS_SCRIPT%" echo $l1.WorkingDirectory = '!TLAUNCHER_DIR!'
>> "%PS_SCRIPT%" echo $l1.Save()
>> "%PS_SCRIPT%" echo $l2 = $ws.CreateShortcut((Join-Path $d 'Servidor Amiguos - Actualizar.lnk'))
>> "%PS_SCRIPT%" echo $l2.TargetPath = '%~dp02-instalar-mods.bat'
>> "%PS_SCRIPT%" echo $l2.WorkingDirectory = '%~dp0'
>> "%PS_SCRIPT%" echo $l2.IconLocation = '!TLAUNCHER_EXE!'
>> "%PS_SCRIPT%" echo $l2.Save()

REM --- Run the PowerShell script ---
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"
set PS_RC=%errorlevel%
del "%PS_SCRIPT%" 2>nul

if %PS_RC% neq 0 (
    echo [ERROR] No se pudieron crear los accesos directos.
) else (
    echo [OK] Accesos directos creados en el escritorio.
)
echo.
echo Presiona una tecla para cerrar (o espera 30 segundos)...
timeout /t 30 /nobreak >nul 2>&1
exit /b 0
