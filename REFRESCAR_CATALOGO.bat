@echo off
echo Actualizando catalogo de LaserSpin Remates...
powershell -ExecutionPolicy Bypass -File update_data.ps1
echo.
echo ¡Catalogo actualizado con exito!
echo Puedes cerrar esta ventana y refrescar tu navegador (F5).
pause
