@echo off
echo ==========================================
echo   TaskManagement - Auto Hot Reload
echo ==========================================
echo.
echo This script monitors file changes and
echo automatically triggers hot reload.
echo.
echo Requirements:
echo - Flutter app must be running
echo - VSCode terminal or command prompt with flutter run
echo.
echo Press Ctrl+C to stop
echo.

:: Check if pubspec.yaml exists
if not exist "pubspec.yaml" (
    echo [ERROR] pubspec.yaml not found!
    echo Please run this script from the project root.
    pause
    exit /b 1
)

echo [INFO] Starting file watcher for auto-reload...
echo [INFO] Monitoring lib/ directory for changes...
echo.

:: Use PowerShell to watch files and send reload command
powershell -ExecutionPolicy Bypass -Command "& {
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = 'lib'
    $watcher.IncludeSubdirectories = $true
    $watcher.Filter = '*.dart'
    $watcher.EnableRaisingEvents = $true
    
    Write-Host '[INFO] Watching for changes...' -ForegroundColor Green
    
    $action = {
        $path = $Event.SourceEventArgs.FullPath
        $changeType = $Event.SourceEventArgs.ChangeType
        $timeStamp = Get-Date -Format 'HH:mm:ss'
        
        if ($changeType -eq 'Changed' -or $changeType -eq 'Created') {
            Write-Host "[$timeStamp] File $changeType`: $path" -ForegroundColor Yellow
            
            # Small delay to batch multiple rapid changes
            Start-Sleep -Milliseconds 500
            
            # Send 'r' key to the Flutter process
            $flutterProcess = Get-Process | Where-Object { $_.ProcessName -like '*flutter*' -or $_.MainWindowTitle -like '*flutter*' }
            if ($flutterProcess) {
                # Use SendKeys to send 'r' to the active window
                Add-Type -AssemblyName System.Windows.Forms
                [System.Windows.Forms.SendKeys]::SendWait('r')
                Write-Host "[$timeStamp] Hot reload triggered!" -ForegroundColor Green
            }
        }
    }
    
    Register-ObjectEvent $watcher 'Changed' -Action $action
    Register-ObjectEvent $watcher 'Created' -Action $action
    
    Write-Host '[INFO] Press Ctrl+C to stop watching...' -ForegroundColor Cyan
    
    # Keep the script running
    while ($true) {
        Start-Sleep -Seconds 1
    }
}"

echo.
echo [INFO] Auto-reload stopped.
pause
