@echo off
echo ==========================================
echo   TaskManagement - Run with Emulator
echo ==========================================
echo.

:: Set paths
set FLUTTER_PATH=C:\development\flutter\bin\flutter.bat
set ANDROID_SDK=C:\Android\Sdk

set ADB_PATH=%ANDROID_SDK%\platform-tools\adb.exe
set EMULATOR_PATH=%ANDROID_SDK%\emulator\emulator.exe

echo [INFO] Checking Android SDK...

:: Check if Android SDK exists
if not exist "%ANDROID_SDK%" (
    echo [ERROR] Android SDK not found at C:\Android\Sdk
    echo Please install Android SDK or update the path in this script.
    pause
    exit /b 1
)

:: Check if Flutter exists
if not exist "%FLUTTER_PATH%" (
    echo [ERROR] Flutter not found at C:\development\flutter
    pause
    exit /b 1
)


echo [INFO] Checking for connected devices...
"%FLUTTER_PATH%" devices

echo.
echo ==========================================
echo   OPTIONS:
echo ==========================================
echo.
echo 1. Start Android Emulator and Run App
echo 2. Run on Chrome (Web)
echo 3. Run on Windows (Desktop)
echo 4. Exit
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto :emulator
if "%choice%"=="2" goto :chrome
if "%choice%"=="3" goto :windows
if "%choice%"=="4" goto :exit
goto :exit

:emulator
echo.
echo [INFO] Checking if emulator is running...
"%ADB_PATH%" devices | findstr "emulator" >nul
if %errorlevel% == 0 (
    echo [INFO] Emulator already running!
    echo [INFO] Starting app on emulator...
    "%FLUTTER_PATH%" run -d emulator-5554
) else (
    echo [INFO] No emulator running.
    echo.
    echo Available emulators:
    "%FLUTTER_PATH%" emulators
    echo.
    echo Would you like to start the emulator? (Y/N)
    set /p startemu=
    if /i "%startemu%"=="Y" (
        echo [INFO] Starting Pixel 9 Pro emulator...
        start "Android Emulator" "%EMULATOR_PATH%" -avd Pixel_9_Pro -no-snapshot-load -gpu host
        echo.
        echo [INFO] Waiting for emulator to boot (30 seconds)...
        timeout /t 30 /nobreak >nul
        echo [INFO] Checking connection...
        "%ADB_PATH%" devices
        echo.
        echo [INFO] Starting app...
        "%FLUTTER_PATH%" run -d emulator-5554
    ) else (
        echo [INFO] Cancelled.
        pause
    )
)
goto :exit

:chrome
echo.
echo [INFO] Running on Chrome...
"%FLUTTER_PATH%" run -d chrome
goto :exit

:windows
echo.
echo [INFO] Running on Windows Desktop...
"%FLUTTER_PATH%" run -d windows
goto :exit

:exit
echo.
echo [INFO] Done.
