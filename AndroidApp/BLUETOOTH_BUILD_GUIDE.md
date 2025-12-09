# Android App Build Instructions - Bluetooth Version

## Overview
This Android app controls Zarif's Robotic Car via **Bluetooth (HC-05/HC-06)**. It has been converted from WiFi/HTTP to Bluetooth Serial communication.

## Prerequisites
- Android Studio (latest version recommended)
- Java Development Kit (JDK) 8 or higher
- Android SDK (API level 21-33)
- Android phone with Bluetooth capability
- HC-05 or HC-06 Bluetooth module paired with your phone

## Building the APK

### Method 1: Using Android Studio (Recommended)
1. Open Android Studio
2. Click "Open an Existing Project"
3. Navigate to `D:\Zarif-s_Robotic_Car\AndroidApp`
4. Wait for Gradle sync to complete
5. Click "Build" → "Build Bundle(s) / APK(s)" → "Build APK(s)"
6. APK will be generated in `AndroidApp/build/outputs/apk/debug/`

### Method 2: Using Gradle Command Line
1. Open PowerShell in `D:\Zarif-s_Robotic_Car\AndroidApp`
2. Run: `./gradlew assembleDebug`
3. APK will be in `build/outputs/apk/debug/app-debug.apk`

### Method 3: Using VS Code with Gradle
1. Open terminal in VS Code
2. Navigate to AndroidApp folder: `cd AndroidApp`
3. Run: `.\gradlew.bat assembleDebug`
4. Find APK in `build/outputs/apk/debug/`

## Installation
1. Enable "Install from Unknown Sources" on your Android phone
2. Transfer the APK to your phone via USB or cloud storage
3. Open the APK on your phone and install
4. Grant Bluetooth permissions when prompted

## First-Time Setup
1. **Pair your phone with HC-05/HC-06 module:**
   - Go to Settings → Bluetooth
   - Search for devices
   - Select "HC-05" or "HC-06"
   - Enter PIN: **1234** (or 0000 if default)
   
2. **Launch "Zarif's Car" app**
3. Click "Connect Bluetooth" button
4. Select your HC-05/HC-06 device from the list
5. Wait for "Connected" status

## Usage

### Manual Mode
1. Switch "Manual Mode" toggle ON
2. Control panel buttons appear
3. Press and hold direction buttons:
   - ↑ FORWARD
   - ↓ BACKWARD
   - ← LEFT (tank turn)
   - → RIGHT (tank turn)
4. Release button to STOP

### Auto Mode
1. Switch "Manual Mode" toggle OFF
2. Mode changes to "Mode: AUTO"
3. Car will avoid obstacles automatically:
   - Detects obstacles at 30cm
   - Backs up 400ms
   - Scans left (30°) and right (150°)
   - Turns toward clearer path
   - Continues forward

## Troubleshooting

### "Bluetooth not connected"
- Ensure HC-05/HC-06 is powered and within range
- Check pairing in phone's Bluetooth settings
- Restart Bluetooth on phone
- Click "Disconnect" then "Connect" again

### "Permission denied"
- Go to App Settings → Permissions
- Enable Bluetooth, Location (needed for Android 6-11)

### "Device not found"
- Ensure HC-05 module is powered on (LED blinking)
- Re-pair device in phone's Bluetooth settings
- Check if another app is using Bluetooth

### Car doesn't respond to commands
- Check Bluetooth connection status in app
- Verify HC-05 TX → Arduino Pin 0
- Verify HC-05 RX ← 10kΩ resistor ← Arduino Pin 1
- Ensure Arduino code is uploaded (**disconnect HC-05 from Pin 0/1 during upload!**)
- Check 11.1V battery voltage

### Auto mode doesn't work
- Switch to Auto mode in the app
- Ensure ultrasonic sensor is connected (Pin 2/3)
- Ensure servo is connected (Pin 9)
- Check Serial Monitor in Arduino IDE: should see "Auto mode activated"

## Technical Details
- **Package Name:** com.zarifscar.controller
- **Min SDK:** 21 (Android 5.0 Lollipop)
- **Target SDK:** 33 (Android 13)
- **Bluetooth UUID:** 00001101-0000-1000-8000-00805F9B34FB (SPP - Serial Port Profile)
- **Baud Rate:** 9600 (configured in Arduino code)
- **Command Format:** String terminated with `\n`
- **Commands:**
  - `FORWARD\n`
  - `BACKWARD\n`
  - `LEFT\n`
  - `RIGHT\n`
  - `STOP\n`
  - `MODE:AUTO\n`
  - `MODE:MANUAL\n`

## Code Changes from WiFi Version
- ✅ Removed Volley HTTP library
- ✅ Added BluetoothAdapter, BluetoothSocket
- ✅ Replaced HTTP POST requests with Bluetooth Serial writes
- ✅ Removed status polling (no server timeout)
- ✅ Added device pairing dialog
- ✅ Added Bluetooth permission requests
- ✅ Updated UI: Added Connect button, removed Timer display
- ✅ Changed connection info to "Bluetooth: HC-05/HC-06 | PIN: 1234"

## Permissions Used
```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## Hardware Wiring (HC-05 to Arduino)
Before testing, ensure HC-05 is wired correctly:

```
HC-05 VCC → Arduino 5V
HC-05 GND → Arduino GND
HC-05 TX  → Arduino Pin 0 (RX) DIRECTLY
Arduino Pin 1 (TX) → 10kΩ resistor → HC-05 RX → 10kΩ resistor → GND
```

**⚠️ CRITICAL:** The voltage divider (two 10kΩ resistors) protects HC-05 RX from 5V damage!

## Upload Arduino Code
1. **Disconnect HC-05 from Pin 0 and Pin 1** (removes from TX/RX lines)
2. Connect Arduino to USB
3. Upload `arduino_car.ino` via Arduino IDE
4. Wait for upload complete
5. **Reconnect HC-05 to Pin 0 and Pin 1**
6. Power on with 11.1V battery

## Testing Procedure
1. ✅ Build and install Android APK
2. ✅ Pair phone with HC-05 (Settings → Bluetooth, PIN: 1234)
3. ✅ Wire HC-05 with voltage divider circuit
4. ✅ Upload arduino_car.ino (disconnect HC-05 first!)
5. ✅ Reconnect HC-05 and power on Arduino
6. ✅ Launch app and click "Connect Bluetooth"
7. ✅ Select HC-05 device
8. ✅ Test Manual mode (FORWARD, BACKWARD, LEFT, RIGHT)
9. ✅ Test Auto mode (obstacle avoidance)

## Expected Behavior

### Manual Mode
- Press FORWARD: All 4 motors run forward
- Press BACKWARD: All 4 motors run backward
- Press LEFT: Left motors backward, right motors forward (tank turn)
- Press RIGHT: Right motors backward, left motors forward (tank turn)
- Release button: Motors stop

### Auto Mode
- Car drives forward
- When obstacle detected at 30cm:
  - Servo centers, motors stop
  - Car backs up 400ms
  - Servo looks left (30°), measures distance
  - Servo looks right (150°), measures distance
  - Car turns toward clearer side
  - Servo centers, car continues forward

## Support
If you encounter issues:
1. Check Serial Monitor (9600 baud) for Arduino debug messages
2. Verify all wiring matches `COMPLETE_WIRING_DIAGRAM.md`
3. Test ultrasonic sensor with `ultrasonic_test.ino`
4. Ensure motors work in Manual mode before testing Auto mode
5. Check HC-05 LED: Should blink slowly when paired, fast when unpaired

## File Summary
Modified files for Bluetooth conversion:
- `MainActivity.java` - Complete Bluetooth rewrite
- `activity_main.xml` - Added Connect button, removed Timer
- `AndroidManifest.xml` - Added Bluetooth permissions
- `build.gradle` - Removed Volley dependency, added namespace

---

**Ready to build and test!** 🚗💨
