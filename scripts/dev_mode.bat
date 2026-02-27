@echo off
echo ==========================================
echo   TaskManagement - Development Mode
echo ==========================================
echo.
echo This script starts:
echo 1. Build runner watch (code generation)
echo 2. Flutter run with hot reload enabled
echo.
echo Press Ctrl+C to stop all processes
echo.

:: Check if pubspec.yaml exists
if not exist "pubspec.yaml" (
    echo [ERROR] pubspec.yaml not found!
    echo Please run this script from the project root.
    pause
    exit /b 1
)

:: Check if emulator is running
adb devices | findstr "emulator-5554" >nul
if %errorlevel% neq 0 (
    echo [WARNING] Emulator not detected!
    echo.
    echo Please start the emulator first:
    echo   scripts\start_emulator.bat
    echo.
    echo Or run with a connected device.
    echo.
    choice /C YN /M "Do you want to continue anyway"
    if %errorlevel% == 2 exit /b 1
)

echo [INFO] Starting development mode...
echo.

:: Start build runner watch in a new window
echo [1/2] Starting build runner watch...
start "Build Runner Watch" cmd /k "echo Build Runner Watch && echo. && flutter pub run build_runner watch --delete-conflicting-outputs"

:: Wait a moment for build runner to start
timeout /t 3 /nobreak >nul

:: Start Flutter run
echo [2/2] Starting Flutter app with hot reload...
echo.
echo ==========================================
echo   HOT RELOAD COMMANDS:
echo   r - Hot reload (quick UI updates)
echo   R - Hot restart (full app restart)
echo   q - Quit
echo ==========================================
echo.

flutter run -d emulator-5554 --hot

echo.
echo [INFO] Development mode stopped.
pause
