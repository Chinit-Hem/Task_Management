@echo off
echo ==========================================
echo   TaskManagement - Android Emulator Launcher
echo ==========================================
echo.

:: Set Android SDK path
set ANDROID_SDK=C:\Android\Sdk
set ADB_PATH=%ANDROID_SDK%\platform-tools\adb.exe
set EMULATOR_PATH=%ANDROID_SDK%\emulator\emulator.exe

:: Check if emulator is already running
"%ADB_PATH%" devices | findstr "emulator" >nul
if %errorlevel% == 0 (
    echo [INFO] Emulator is already running!
    "%ADB_PATH%" devices
    echo.
    echo You can now run: flutter run -d emulator-5554
    pause
    exit /b 0
)


:: Verify paths exist
if not exist "%EMULATOR_PATH%" (
    echo [ERROR] Emulator not found at: %EMULATOR_PATH%
    echo.
    echo Please verify your Android SDK installation at C:\Android\Sdk
    echo.
    pause
    exit /b 1
)

if not exist "%ADB_PATH%" (
    echo [ERROR] ADB not found at: %ADB_PATH%
    echo.
    echo Please verify your Android SDK installation.
    echo.
    pause
    exit /b 1
)


echo.
echo [INFO] Starting Android Emulator (Pixel 9 Pro)...
echo [INFO] Using: %EMULATOR_PATH%
echo [INFO] This may take 1-2 minutes...
echo.

"%EMULATOR_PATH%" -avd Pixel_9_Pro -no-snapshot-load -gpu host


if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Emulator failed to start! (Exit code: %errorlevel%)
    echo.
    echo Troubleshooting steps:
    echo   1. Verify virtualization is enabled in BIOS (Intel VT-x or AMD-V)
    echo   2. Enable Windows Hypervisor Platform in Windows Features
    echo   3. Update emulator: sdkmanager --update
    echo   4. Check emulator logs: %USERPROFILE%\.android\avd\Pixel_9_Pro.avd\
    echo   5. Try cold boot: flutter emulators --launch Pixel_9_Pro --cold
    echo.
    pause
    exit /b %errorlevel%
)

echo.
echo [SUCCESS] Emulator started successfully!
echo.
echo Available commands:
echo   - flutter run -d emulator-5554
echo   - flutter devices
echo.
pause
