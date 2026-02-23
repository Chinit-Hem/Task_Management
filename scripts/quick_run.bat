@echo off
echo ==========================================
echo   TaskManagement - Quick Run
echo ==========================================
echo.

:: Set SDK path for this session
set ANDROID_SDK_ROOT=C:\Android\Sdk
set ANDROID_HOME=C:\Android\Sdk

:: Check if emulator is running
C:\Android\Sdk\platform-tools\adb.exe devices | findstr "emulator" >nul
if %errorlevel% neq 0 (
    echo [INFO] Starting emulator...
    start "Android Emulator" "C:\Android\Sdk\emulator\emulator.exe" -avd Pixel_9_Pro -no-snapshot-load -gpu host
    
    echo [INFO] Waiting for emulator to boot...
    timeout /t 30 /nobreak >nul
    
    :WAIT_LOOP
    C:\Android\Sdk\platform-tools\adb.exe devices | findstr "device" | findstr "emulator" >nul
    if %errorlevel% neq 0 (
        echo [INFO] Still waiting...
        timeout /t 5 /nobreak >nul
        goto WAIT_LOOP
    )
    echo [SUCCESS] Emulator ready!
) else (
    echo [INFO] Emulator already running!
)

echo.
echo [INFO] Starting Flutter app with hot reload...
echo [INFO] Press 'r' for hot reload, 'R' for hot restart, 'q' to quit
echo.

cd /d "d:\TaskManagement"
flutter run -d emulator-5554

echo.
pause
