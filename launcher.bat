@echo off
chcp 65001 >nul
setlocal
set "REPO=https://raw.githubusercontent.com/kevinarismendy/modpack-santi/main"
set "SCRIPT=%TEMP%\santicraft_%RANDOM%.bat"

echo ============================================
echo   Servidor Amiguos - Launcher
echo   Bajando codigo desde GitHub...
echo ============================================
echo.

curl.exe -L -sS -o "%SCRIPT%" "%REPO%/install.bat?v=%RANDOM%" || goto :error

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
