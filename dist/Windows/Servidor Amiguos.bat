@echo off
title Servidor Amiguos - Launcher
setlocal

echo ============================================
echo   Servidor Amiguos - Launcher
echo   MC 1.21.1 + Fabric 0.16.5
echo ============================================
echo.

set "SCRIPT_URL=https://github.com/kevinarismendy/modpack-santi/releases/latest/download/install.bat"
set "SCRIPT=%TEMP%\santicraft_%RANDOM%.bat"

curl.exe -L -sS -o "%SCRIPT%" "%SCRIPT_URL%"
if errorlevel 1 goto :error
if not exist "%SCRIPT%" goto :error

call "%SCRIPT%"
set "RC=%errorlevel%"
del "%SCRIPT%" 2>nul

echo.
echo ==========================================
echo   Presiona ENTER para cerrar
echo ==========================================
pause
exit /b %RC%

:error
echo.
echo [ERROR] No se pudo conectar a GitHub.
echo Verifica tu conexion a internet.
echo.
pause
exit /b 1
