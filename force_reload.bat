@echo off
echo ==========================================
echo   Force Hot Reload - TaskManagement
echo ==========================================
echo.

:: Method 1: Try to find and activate Flutter terminal
echo [INFO] Searching for Flutter process...

:: Use PowerShell to find and send keys to Flutter terminal
powershell -Command "$wshell = New-Object -ComObject wscript.shell; $wshell.AppActivate('flutter'); Start-Sleep -m 500; $wshell.SendKeys('r')"

echo [INFO] Hot reload signal sent!
echo.
echo If the emulator still doesn't update:
echo   1. Click on the terminal running 'flutter run'
echo   2. Press 'r' key manually
echo   3. Or press 'R' for hot restart
echo.
pause
