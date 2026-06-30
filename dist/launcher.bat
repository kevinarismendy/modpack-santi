@echo off
chcp 65001 >nul
setlocal
set "SCRIPT_URL=https://github.com/kevinarismendy/modpack-santi/releases/latest/download/install.bat"
set "SCRIPT=%TEMP%\santicraft_%RANDOM%.bat"

echo ============================================
echo   Servidor Amiguos - Launcher
echo   Bajando codigo desde GitHub...
echo ============================================
echo.

REM --- Auto-elevar a admin si hace falta (el instalador necesita UAC) ---
net session >nul 2>&1
if errorlevel 1 (
    echo [Setup] Requiriendo permisos de Administrador (UAC)...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WorkingDirectory '%~dp0'"
    exit /b 0
)

curl.exe -L -sS -o "%SCRIPT%" "%SCRIPT_URL%" || goto :error

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
