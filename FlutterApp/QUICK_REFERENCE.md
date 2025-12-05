# Flutter App - Quick Reference

## 🚀 Quick Start Commands

```powershell
# Navigate to project
cd d:\Zarif-s_Robotic_Car\FlutterApp

# Run setup script (first time only)
.\setup.ps1

# Get dependencies
flutter pub get

# Run app (debug mode)
flutter run

# Build release APK
flutter build apk --release
```

## 📁 Key Files to Know

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/providers/car_controller.dart` | All control logic |
| `lib/services/api_service.dart` | HTTP API calls |
| `lib/screens/home_screen.dart` | Main UI screen |
| `pubspec.yaml` | Dependencies |
| `android/app/build.gradle` | Android config |

## 🎨 UI Components

| Widget | Description |
|--------|-------------|
| AnimatedTitle | Fading "ZARIF'S CAR" text |
| CarIcon | Animated car drawing |
| StatusCard | Mode & connection display |
| ModeSwitch | AUTO ↔ MANUAL toggle |
| ControlPanel | 4 control buttons |
| ConnectionInfo | WiFi credentials |

## 🔧 Common Issues & Fixes

| Problem | Solution |
|---------|----------|
| "Flutter not found" | Add Flutter to PATH |
| "Android licenses" | Run `flutter doctor --android-licenses` |
| "Gradle build failed" | Run `flutter clean` then rebuild |
| "Can't connect to car" | Check WiFi connection to "Zarifs Car" |
| "Buttons not working" | Enable Manual Mode first |

## 📡 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/mode` | POST | Switch AUTO/MANUAL |
| `/control` | POST | Send movement command |
| `/status` | GET | Get mode & timer status |

## 🎮 Control Commands

- `FORWARD` - Move forward
- `BACKWARD` - Move backward
- `LEFT` - Rotate left
- `RIGHT` - Rotate right
- `STOP` - Stop motors

## 📱 App Features

✅ Touch & hold buttons (continuous movement)
✅ Auto-reconnect on timeout
✅ 5-minute countdown timer
✅ Connection status indicator
✅ Smooth animations
✅ Material Design 3

## 🔄 Development Workflow

1. Make code changes
2. Save files (auto hot-reload in debug mode)
3. Test on device/emulator
4. Build release APK when ready

## 📦 APK Locations

**Debug:** `build\app\outputs\flutter-apk\app-debug.apk`
**Release:** `build\app\outputs\flutter-apk\app-release.apk`

## 🌐 Network Settings

- **Base URL:** http://192.168.4.1
- **WiFi SSID:** Zarifs Car
- **Password:** 12344321
- **Timeout:** 5 seconds per request

## 🎯 State Management

Uses **Provider** pattern:
- `CarController` manages all app state
- Widgets listen via `Consumer<CarController>`
- Changes trigger automatic UI updates

## ⚡ Performance

- Command rate: 20 Hz (50ms intervals)
- Status updates: 1 Hz (1 second intervals)
- APK size: ~15-20 MB (release)
- Min Android: 5.0 (API 21)

---

**Need help?** Check `BUILD_INSTRUCTIONS.md` for detailed guide.
