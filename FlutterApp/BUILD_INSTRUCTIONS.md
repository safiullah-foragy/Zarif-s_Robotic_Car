# Flutter App Build and Run Instructions

## 📱 Zarif's Car - Flutter App

Complete guide to build and run the Flutter-based Android app for controlling Zarif's Robotic Car.

---

## 🔧 Prerequisites

### 1. Install Flutter SDK

**Windows:**
1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`

**Verify installation:**
```powershell
flutter doctor
```

### 2. Install Android Studio
1. Download from: https://developer.android.com/studio
2. Install Android SDK
3. Install Flutter and Dart plugins:
   - Open Android Studio → Settings → Plugins
   - Search and install "Flutter" (includes Dart)

### 3. Setup Android Emulator or Physical Device

**For Physical Device:**
- Enable Developer Options (tap Build Number 7 times)
- Enable USB Debugging
- Connect via USB

**For Emulator:**
- Open Android Studio → AVD Manager
- Create Virtual Device (Recommended: Pixel 5, API 33+)

---

## 🚀 Build Instructions

### Step 1: Navigate to Project Directory
```powershell
cd d:\Zarif-s_Robotic_Car\FlutterApp
```

### Step 2: Get Dependencies
```powershell
flutter pub get
```

This will download all required packages:
- `http` - For API communication
- `provider` - For state management
- `flutter_animate` - For animations

### Step 3: Check Connected Devices
```powershell
flutter devices
```

You should see your Android device or emulator listed.

### Step 4: Run the App

**Debug Mode (Development):**
```powershell
flutter run
```

**Release Mode (Production):**
```powershell
flutter run --release
```

### Step 5: Build APK

**Debug APK:**
```powershell
flutter build apk --debug
```
Output: `build\app\outputs\flutter-apk\app-debug.apk`

**Release APK (Optimized):**
```powershell
flutter build apk --release
```
Output: `build\app\outputs\flutter-apk\app-release.apk`

**Split APKs by ABI (Smaller size):**
```powershell
flutter build apk --split-per-abi --release
```
Outputs:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

---

## 📦 Install APK

### Method 1: Direct Install via Flutter
```powershell
flutter install
```

### Method 2: ADB Install
```powershell
adb install build\app\outputs\flutter-apk\app-release.apk
```

### Method 3: Manual Transfer
1. Copy APK to phone via USB or cloud
2. Open file manager on phone
3. Tap APK file
4. Enable "Install from Unknown Sources" if prompted
5. Install and open

---

## 🎯 Project Structure

```
FlutterApp/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── providers/
│   │   └── car_controller.dart      # State management & logic
│   ├── services/
│   │   └── api_service.dart         # HTTP API communication
│   ├── screens/
│   │   └── home_screen.dart         # Main UI screen
│   └── widgets/
│       ├── animated_title.dart      # Animated "ZARIF'S CAR" title
│       ├── car_icon.dart            # Custom car icon with animation
│       ├── status_card.dart         # Status display widget
│       ├── mode_switch.dart         # Auto/Manual mode switch
│       ├── control_panel.dart       # Control buttons (4 directions)
│       └── connection_info.dart     # WiFi connection info
├── android/
│   └── app/
│       ├── build.gradle             # Android build configuration
│       └── src/main/AndroidManifest.xml
└── pubspec.yaml                     # Flutter dependencies
```

---

## 🎨 Features Implemented

✅ **Animated Title** - Fading "ZARIF'S CAR" text
✅ **Custom Car Icon** - Hand-drawn car with rotation animation
✅ **Status Display** - Shows AUTO/MANUAL mode with connection indicator
✅ **Mode Switch** - Toggle between modes with Material Design switch
✅ **Touch & Hold Controls** - 4 circular buttons for movement
✅ **5-Minute Timer** - Countdown display in manual mode
✅ **Auto-Reconnect** - Handles mode timeout from server
✅ **Connection Status** - Real-time connection indicator
✅ **Beautiful UI** - Gradient background with smooth animations

---

## 🔍 Troubleshooting

### Flutter Doctor Issues

**Android licenses not accepted:**
```powershell
flutter doctor --android-licenses
```

**SDK not found:**
- Open Android Studio → SDK Manager
- Install latest Android SDK

### Build Errors

**Error: "Gradle build failed"**
```powershell
cd android
.\gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

**Error: "Unable to resolve dependency"**
```powershell
flutter pub cache repair
flutter pub get
```

### Runtime Issues

**Error: "SocketException"**
- Ensure phone is connected to "Zarifs Car" WiFi (192.168.4.1)
- Check ESP8266 is powered on and broadcasting

**Error: "App crashes on startup"**
- Check `flutter run` logs for stack trace
- Verify AndroidManifest.xml has required permissions

**Controls not responding:**
- Verify manual mode is enabled (switch is ON)
- Check network connectivity
- Ensure ESP8266 web server is running

---

## 🧪 Testing

### Run on Device
```powershell
flutter run --release
```

### Check Performance
```powershell
flutter run --profile
```

### Run Tests (if you add them)
```powershell
flutter test
```

---

## 📊 APK Size Optimization

**Current size:** ~15-20 MB (release build)

**Further optimize:**
```powershell
flutter build apk --release --shrink --split-per-abi
```

This creates separate APKs for different CPU architectures, each ~8-10 MB.

---

## 🔄 Hot Reload During Development

While running `flutter run`:
- Press `r` - Hot reload (fast refresh)
- Press `R` - Hot restart (full restart)
- Press `q` - Quit

---

## 📱 Minimum Requirements

- **Android:** 5.0 (Lollipop) or higher (API 21+)
- **RAM:** 2 GB minimum
- **Storage:** 50 MB free space
- **WiFi:** Required for car communication

---

## 🌐 Network Configuration

The app connects to:
- **IP:** 192.168.4.1
- **WiFi SSID:** Zarifs Car
- **WiFi Password:** 12344321

---

## 🛠️ Development Commands

```powershell
# Get dependencies
flutter pub get

# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Build APK
flutter build apk --release

# Install on device
flutter install

# Clean build cache
flutter clean

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Check outdated packages
flutter pub outdated

# Update packages
flutter pub upgrade
```

---

## 📝 State Management

The app uses **Provider** for state management:

- `CarController` - Main controller class
  - Manages mode (AUTO/MANUAL)
  - Handles continuous command sending
  - Monitors connection status
  - Tracks timer countdown
  - Communicates with ESP8266 via HTTP

---

## 🎮 Control Flow

1. App starts → Status updates begin (1 Hz)
2. User toggles Manual Mode → POST /mode
3. User presses button → Continuous commands (20 Hz)
4. User releases button → STOP command sent
5. 5 minutes inactivity → Server switches to AUTO
6. App detects mode change → Updates UI

---

## 🚀 Next Steps

After building:
1. Install APK on Android phone
2. Connect phone to "Zarifs Car" WiFi
3. Open Zarif's Car app
4. Toggle Manual Mode and test controls
5. Verify auto-timeout after 5 minutes

---

## 📄 License

Open-source project for educational purposes.

## 👨‍💻 Built With

- Flutter 3.0+
- Dart 3.0+
- Provider (State Management)
- HTTP (Network Communication)
- Material Design 3

---

**Happy Coding! 🎉**

Your Flutter app is ready to control Zarif's Robotic Car!
