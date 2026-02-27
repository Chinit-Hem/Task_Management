@echo off
echo ==========================================
echo   Android Emulator - Complete Fix & Run
echo ==========================================
echo.

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] This script needs Administrator privileges!
    echo [INFO] Please right-click and select "Run as Administrator"
    echo.
    pause
    exit /b 1
)

echo [INFO] Running with Administrator privileges...
echo.

:: ==========================================
:: Step 1: Enable Windows Hypervisor Platform
:: ==========================================
echo [STEP 1] Enabling Windows Hypervisor Platform...
echo This is required for Android emulator to work...
echo.

dism /online /enable-feature /featurename:HypervisorPlatform /all /norestart
if %errorlevel% == 0 (
    echo [SUCCESS] Windows Hypervisor Platform enabled!
) else (
    echo [INFO] Windows Hypervisor Platform may already be enabled or requires restart.
)
echo.

:: ==========================================
:: Step 2: Set Environment Variables
:: ==========================================
echo [STEP 2] Setting Android SDK Environment Variables...
echo.

setx ANDROID_SDK_ROOT "C:\Android\Sdk" /M
setx ANDROID_HOME "C:\Android\Sdk" /M

:: Add to PATH if not already there
echo [INFO] Updating PATH...
setx PATH "%PATH%;C:\Android\Sdk\platform-tools;C:\Android\Sdk\emulator" /M

echo [SUCCESS] Environment variables set:
echo   ANDROID_SDK_ROOT = C:\Android\Sdk
echo   ANDROID_HOME = C:\Android\Sdk
echo.

:: ==========================================
:: Step 3: Restart ADB Server
:: ==========================================
echo [STEP 3] Restarting ADB Server...
echo.

taskkill /F /IM adb.exe 2>nul
timeout /t 2 /nobreak >nul

C:\Android\Sdk\platform-tools\adb.exe start-server
if %errorlevel% == 0 (
    echo [SUCCESS] ADB server restarted!
) else (
    echo [WARNING] ADB restart had issues, continuing...
)
echo.

:: ==========================================
:: Step 4: Check for running emulator
:: ==========================================
echo [STEP 4] Checking for existing emulator...
echo.

C:\Android\Sdk\platform-tools\adb.exe devices | findstr "emulator" >nul
if %errorlevel% == 0 (
    echo [INFO] Emulator is already running!
    C:\Android\Sdk\platform-tools\adb.exe devices
    echo.
    goto RUN_FLUTTER
) else (
    echo [INFO] No emulator running. Starting emulator...
)
echo.

:: ==========================================
:: Step 5: Start Android Emulator
:: ==========================================
echo [STEP 5] Starting Android Emulator (Pixel 9 Pro)...
echo [INFO] This will take 1-2 minutes for first boot...
echo [INFO] Window will open - please wait for it to fully load...
echo.

start "Android Emulator" "C:\Android\Sdk\emulator\emulator.exe" -avd Pixel_9_Pro -no-snapshot-load -gpu host

echo [INFO] Emulator starting in separate window...
echo [INFO] Waiting 30 seconds for emulator to boot...
echo.

timeout /t 30 /nobreak >nul

:: Wait for device to be ready
echo [INFO] Waiting for device to be ready...
:WAIT_LOOP
C:\Android\Sdk\platform-tools\adb.exe devices | findstr "device" | findstr "emulator" >nul
if %errorlevel% neq 0 (
    echo [INFO] Still waiting for emulator...
    timeout /t 5 /nobreak >nul
    goto WAIT_LOOP
)

echo [SUCCESS] Emulator is ready!
C:\Android\Sdk\platform-tools\adb.exe devices
echo.

:: ==========================================
:: Step 6: Run Flutter App
:: ==========================================
:RUN_FLUTTER
echo [STEP 6] Running Flutter App...
echo.

cd /d "d:\TaskManagement"

echo [INFO] Checking Flutter setup...
flutter doctor -v | findstr "Android toolchain"
echo.

echo [INFO] Starting Flutter app with hot reload...
echo [INFO] Press 'r' for hot reload, 'R' for hot restart, 'q' to quit
echo.

flutter run -d emulator-5554

echo.
echo ==========================================
echo   Session Complete
echo ==========================================
echo.
pause
