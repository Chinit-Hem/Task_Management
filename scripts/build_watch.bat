@echo off
echo ==========================================
echo   TaskManagement - Build Runner Watch
echo ==========================================
echo.
echo This script watches for code changes and
echo automatically rebuilds generated files.
echo.
echo Press Ctrl+C to stop watching
echo.

:: Check if pubspec.yaml exists
if not exist "pubspec.yaml" (
    echo [ERROR] pubspec.yaml not found!
    echo Please run this script from the project root.
    pause
    exit /b 1
)

echo [INFO] Starting build_runner watch...
echo [INFO] This will monitor .dart files and rebuild .g.dart files automatically
echo.

:: Run build_runner in watch mode
flutter pub run build_runner watch --delete-conflicting-outputs

echo.
echo [INFO] Build watch stopped.
pause
