@echo off
echo ==========================================
echo   Finding Android Emulator Path
echo ==========================================
echo.

echo [INFO] Checking common Android SDK locations...
echo.

:: Check location 1: AppData\Local\Android\sdk
if exist "C:\Users\%USERNAME%\AppData\Local\Android\sdk\emulator\emulator.exe" (
    echo [FOUND] Android SDK at:
    echo   C:\Users\%USERNAME%\AppData\Local\Android\sdk
    echo   Emulator: C:\Users\%USERNAME%\AppData\Local\Android\sdk\emulator\emulator.exe
    echo.
)

:: Check location 2: C:\Android\Sdk
if exist "C:\Android\Sdk\emulator\emulator.exe" (
    echo [FOUND] Android SDK at:
    echo   C:\Android\Sdk
    echo   Emulator: C:\Android\Sdk\emulator\emulator.exe
    echo.
)

:: Check location 3: Program Files
if exist "C:\Program Files\Android\Android Studio\sdk\emulator\emulator.exe" (
    echo [FOUND] Android SDK at:
    echo   C:\Program Files\Android\Android Studio\sdk
    echo   Emulator: C:\Program Files\Android\Android Studio\sdk\emulator\emulator.exe
    echo.
)

:: Check environment variables
echo [INFO] Checking environment variables...
echo.
if defined ANDROID_SDK_ROOT (
    echo ANDROID_SDK_ROOT = %ANDROID_SDK_ROOT%
    if exist "%ANDROID_SDK_ROOT%\emulator\emulator.exe" (
        echo   [FOUND] emulator.exe at %ANDROID_SDK_ROOT%\emulator\emulator.exe
    ) else (
        echo   [NOT FOUND] emulator.exe at %ANDROID_SDK_ROOT%\emulator\emulator.exe
    )
) else (
    echo ANDROID_SDK_ROOT: Not set
)
echo.

if defined ANDROID_HOME (
    echo ANDROID_HOME = %ANDROID_HOME%
    if exist "%ANDROID_HOME%\emulator\emulator.exe" (
        echo   [FOUND] emulator.exe at %ANDROID_HOME%\emulator\emulator.exe
    ) else (
        echo   [NOT FOUND] emulator.exe at %ANDROID_HOME%\emulator\emulator.exe
    )
) else (
    echo ANDROID_HOME: Not set
)
echo.

:: List available emulators
echo [INFO] Listing available emulators...
flutter emulators
echo.

:: Check if any emulator is currently running
echo [INFO] Checking for running emulators...
adb devices
echo.

echo ==========================================
echo   Recommended VS Code Settings
echo ==========================================
echo.
echo Add this to your .vscode\settings.json:
echo.
echo {
echo     "dart.flutterSdkPath": "D:\\RUPP\\flutter",
echo     "android.sdkPath": "C:\\Users\\%USERNAME%\\AppData\\Local\\Android\\sdk"
echo }
echo.
echo Or if using C:\Android\Sdk:
echo.
echo {
echo     "dart.flutterSdkPath": "D:\\RUPP\\flutter",
echo     "android.sdkPath": "C:\\Android\\Sdk"
echo }
echo.

pause
