# 🚀 Run TaskManagement on Emulator

## Quick Start Options

### Option 1: Run with Chrome (Fastest - No Emulator Needed)
```bash
C:\flutter\bin\flutter.bat run -d chrome
```
This will open the app in Chrome browser with hot reload enabled.

### Option 2: Run with Windows Desktop
```bash
C:\flutter\bin\flutter.bat run -d windows
```
This runs as a native Windows app.

### Option 3: Run on Android Emulator
```bash
# Step 1: Start the emulator (if not running)
C:\Android\Sdk\emulator\emulator.exe -avd Pixel_9_Pro

# Step 2: Wait 30-60 seconds for boot

# Step 3: Run the app
C:\flutter\bin\flutter.bat run -d emulator-5554
```

## 📱 What Was Updated

### 1. Phone Number Updated to +855 011 311 161
- **Profile Screen** (`lib/screens/profile_screen.dart`)
- **Privacy Policy Screen** (`lib/screens/privacy_policy_screen.dart`)

### 2. Google Sign-In Added
- **Login Screen** (`lib/screens/login_screen.dart`)
  - New "Continue with Google" button
  - Google account picker functionality
  - OR divider separator

## 🔄 Hot Reload Methods

Once the app is running, use these to see updates:

### Method 1: Interactive Terminal
When the app is running, the terminal shows:
```
Flutter run key commands.
r Hot reload. 🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).
```

**Press `r`** in the terminal for hot reload
**Press `R`** for hot restart (more thorough)

### Method 2: Use Helper Scripts
```bash
# Force hot reload
force_reload.bat

# Hot restart (better for major changes)
hot_restart.bat

# Run with options menu
run_with_emulator.bat
```

### Method 3: VS Code (Recommended)
1. Open VS Code
2. Press `F5` or go to **Run > Start Debugging**
3. Select **"TaskManagement (Emulator)"**
4. Hot reload works automatically on save

## 🛠️ Troubleshooting

### "No supported devices found"
```bash
# List available devices
C:\flutter\bin\flutter.bat devices

# List emulators
C:\flutter\bin\flutter.bat emulators

# Start specific emulator
C:\flutter\bin\flutter.bat emulators --launch Pixel_9_Pro
```

### Changes not showing?
1. **Try Hot Restart** (Press `R` in terminal) - more thorough than hot reload
2. **Stop and restart** the app completely
3. **Check for errors** in the terminal output

### Emulator won't start?
- Enable virtualization in BIOS (Intel VT-x or AMD-V)
- Enable Windows Hypervisor Platform in Windows Features
- Update Android Emulator through SDK Manager

## ✅ Recommended Workflow

1. **First time**: Use Chrome for quick testing
   ```bash
   C:\flutter\bin\flutter.bat run -d chrome
   ```

2. **For final testing**: Use Android Emulator
   ```bash
   run_with_emulator.bat
   ```

3. **During development**: Keep terminal open and press `r` to reload

---

**Your changes are saved and ready!** The phone number is updated and Google Sign-In is added. Just run the app using any method above to see them. 🎉
