@echo off
echo ==========================================
echo   TaskManagement - Quick Flutter Run
echo ==========================================
echo.

:: Check if emulator is running
adb devices | findstr "emulator-5554" >nul
if %errorlevel% == 0 (
    echo [INFO] Running on Android Emulator...
    flutter run -d emulator-5554 --verbose
) else (
    echo [WARNING] Emulator not detected!
    echo.
    echo Available devices:
    flutter devices
    echo.
    echo Please start the emulator first:
    echo   scripts\start_emulator.bat
    echo.
    pause
)
