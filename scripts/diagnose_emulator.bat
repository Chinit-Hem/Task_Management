@echo off
echo ==========================================
echo   Android Emulator Diagnostics
echo ==========================================
echo.

:: Check Windows version
echo [INFO] Windows Version:
ver
echo.

:: Check system architecture
echo [INFO] System Architecture:
echo %PROCESSOR_ARCHITECTURE%
echo.

:: Check if Hyper-V is enabled (required for emulator)
echo [INFO] Checking Hyper-V status...
systeminfo | findstr /B /C:"Hyper-V Requirements"
echo.

:: Check available memory
echo [INFO] Available Memory:
systeminfo | findstr /B /C:"Total Physical Memory"
systeminfo | findstr /B /C:"Available Physical Memory"
echo.

:: Check if Intel HAXM or Windows Hypervisor Platform is installed
echo [INFO] Checking virtualization support...
echo.

:: Check for HAXM
if exist "C:\Users\%USERNAME%\AppData\Local\Android\sdk\extras\intel\Hardware_Accelerated_Execution_Manager" (
    echo [FOUND] Intel HAXM installed
) else (
    echo [NOT FOUND] Intel HAXM
)
echo.

:: Check Windows features for Hypervisor Platform
dism /online /get-features | findstr /i "hypervisor" | findstr /i "Enabled"
if %errorlevel% == 0 (
    echo [ENABLED] Windows Hypervisor Platform
) else (
    echo [NOT ENABLED] Windows Hypervisor Platform - This may be required!
)
echo.

:: Check emulator logs if they exist
echo [INFO] Checking for emulator logs...
if exist "%USERPROFILE%\.android\avd\Pixel_9_Pro.avd\emulator-user.ini" (
    echo [FOUND] Pixel 9 Pro AVD exists
    type "%USERPROFILE%\.android\avd\Pixel_9_Pro.avd\emulator-user.ini"
) else (
    echo [NOT FOUND] Pixel 9 Pro AVD configuration
)
echo.

:: Try to get more detailed error
echo [INFO] Attempting to start emulator with verbose output...
echo This will show detailed error messages...
echo.

echo Choose SDK location:
echo 1. C:\Users\%USERNAME%\AppData\Local\Android\sdk
echo 2. C:\Android\Sdk
echo 3. Other (specify in ANDROID_SDK_ROOT)
echo.

set /p choice="Enter choice (1-3): "

if "%choice%"=="1" (
    set EMULATOR_PATH=C:\Users\%USERNAME%\AppData\Local\Android\sdk\emulator\emulator.exe
    set SDK_PATH=C:\Users\%USERNAME%\AppData\Local\Android\sdk
) else if "%choice%"=="2" (
    set EMULATOR_PATH=C:\Android\Sdk\emulator\emulator.exe
    set SDK_PATH=C:\Android\Sdk
) else (
    if defined ANDROID_SDK_ROOT (
        set EMULATOR_PATH=%ANDROID_SDK_ROOT%\emulator\emulator.exe
        set SDK_PATH=%ANDROID_SDK_ROOT%
    ) else (
        echo ERROR: ANDROID_SDK_ROOT not set!
        pause
        exit /b 1
    )
)

echo.
echo [INFO] Using emulator at: %EMULATOR_PATH%
echo [INFO] SDK path: %SDK_PATH%
echo.

if not exist "%EMULATOR_PATH%" (
    echo [ERROR] Emulator not found at %EMULATOR_PATH%
    echo Please verify the path and try again.
    pause
    exit /b 1
)

echo [INFO] Starting emulator with verbose logging...
echo.
"%EMULATOR_PATH%" -avd Pixel_9_Pro -verbose -no-snapshot-load 2>&1

echo.
echo [INFO] Emulator exited with code: %errorlevel%
echo.

pause
