@echo off
echo ==========================================
echo   Hot Restart - TaskManagement
echo ==========================================
echo.

:: Send Shift+R for hot restart (more effective for dependency changes)
echo [INFO] Sending hot restart signal...

:: Use PowerShell to send Shift+R
powershell -Command "$wshell = New-Object -ComObject wscript.shell; $wshell.AppActivate('flutter'); Start-Sleep -m 500; $wshell.SendKeys('+r')"

echo [INFO] Hot restart signal sent!
echo.
echo This will fully restart the app with all changes.
echo.
pause
