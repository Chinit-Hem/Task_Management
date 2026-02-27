# PowerShell script to send 'r' to the Flutter terminal for hot reload
$flutterProcess = Get-Process | Where-Object { $_.ProcessName -like "*flutter*" -or $_.MainWindowTitle -like "*flutter*" } | Select-Object -First 1

if ($flutterProcess) {
    # Use Windows API to send keystroke
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Keyboard {
        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
        
        [DllImport("user32.dll")]
        public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, int dwExtraInfo);
    }
"@
    
    # Bring window to foreground and send 'r'
    [Keyboard]::SetForegroundWindow($flutterProcess.MainWindowHandle)
    Start-Sleep -Milliseconds 500
    
    # Send 'r' key (virtual key code 0x52)
    [Keyboard]::keybd_event(0x52, 0, 0, 0)  # Key down
    Start-Sleep -Milliseconds 50
    [Keyboard]::keybd_event(0x52, 0, 2, 0)  # Key up
    
    Write-Host "Hot reload triggered!"
} else {
    Write-Host "Flutter process not found. Trying alternative method..."
    
    # Alternative: Find any PowerShell or CMD window with flutter running
    $windows = Get-Process | Where-Object { 
        $_.ProcessName -eq "powershell" -or 
        $_.ProcessName -eq "cmd" -or 
        $_.ProcessName -eq "WindowsTerminal" 
    }
    
    foreach ($window in $windows) {
        if ($window.MainWindowTitle -like "*TaskManagement*" -or 
            $window.MainWindowTitle -like "*flutter*") {
            [Keyboard]::SetForegroundWindow($window.MainWindowHandle)
            Start-Sleep -Milliseconds 500
            [Keyboard]::keybd_event(0x52, 0, 0, 0)
            Start-Sleep -Milliseconds 50
            [Keyboard]::keybd_event(0x52, 0, 2, 0)
            Write-Host "Hot reload sent to: $($window.MainWindowTitle)"
            break
        }
    }
}
