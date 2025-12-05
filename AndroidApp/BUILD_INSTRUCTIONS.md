# Android App Build Instructions

## Prerequisites
- Android Studio (Latest version recommended)
- Android SDK (API Level 21 or higher)
- Java Development Kit (JDK 8 or higher)

## Step-by-Step Build Process

### 1. Create New Android Project
1. Open Android Studio
2. Click "New Project"
3. Select "Empty Activity"
4. Configure:
   - Name: `Zarifs Car Controller`
   - Package name: `com.zarifscar.controller`
   - Language: `Java`
   - Minimum SDK: `API 21: Android 5.0 (Lollipop)`
5. Click "Finish"

### 2. Copy Project Files

#### Copy Java Source:
```
AndroidApp/MainActivity.java
  → app/src/main/java/com/zarifscar/controller/MainActivity.java
```

#### Copy Layout:
```
AndroidApp/res/layout/activity_main.xml
  → app/src/main/res/layout/activity_main.xml
```

#### Copy Manifest:
```
AndroidApp/AndroidManifest.xml
  → app/src/main/AndroidManifest.xml
```

#### Copy Drawables:
```
AndroidApp/res/drawable/gradient_background.xml
  → app/src/main/res/drawable/gradient_background.xml

AndroidApp/res/drawable/button_forward.xml
  → app/src/main/res/drawable/button_forward.xml

AndroidApp/res/drawable/button_backward.xml
  → app/src/main/res/drawable/button_backward.xml

AndroidApp/res/drawable/button_left.xml
  → app/src/main/res/drawable/button_left.xml

AndroidApp/res/drawable/button_right.xml
  → app/src/main/res/drawable/button_right.xml

AndroidApp/res/drawable/status_background.xml
  → app/src/main/res/drawable/status_background.xml

AndroidApp/res/drawable/switch_container_background.xml
  → app/src/main/res/drawable/switch_container_background.xml

AndroidApp/res/drawable/ic_car.xml
  → app/src/main/res/drawable/ic_car.xml
```

#### Copy Values:
```
AndroidApp/res/values/themes.xml
  → app/src/main/res/values/themes.xml

AndroidApp/res/values/colors.xml
  → app/src/main/res/values/colors.xml

AndroidApp/res/values/strings.xml
  → app/src/main/res/values/strings.xml
```

#### Update build.gradle:
Replace the contents of `app/build.gradle` with:
```
AndroidApp/build.gradle
  → app/build.gradle
```

### 3. Sync and Build

1. Click "Sync Project with Gradle Files" (or press Ctrl+Shift+O)
2. Wait for Gradle sync to complete
3. Resolve any dependency issues if they appear

### 4. Build APK

#### Option A: Debug APK (for testing)
1. Go to Build → Build Bundle(s) / APK(s) → Build APK(s)
2. Wait for build to complete
3. Click "locate" in the notification to find the APK
4. APK location: `app/build/outputs/apk/debug/app-debug.apk`

#### Option B: Release APK (for distribution)
1. Go to Build → Generate Signed Bundle / APK
2. Select "APK" and click Next
3. Create or select a keystore:
   - If creating new:
     - Key store path: Choose location
     - Password: Create a password
     - Key alias: `zarifscar`
     - Key password: Create a password
     - Validity: 25 years
     - Certificate info: Fill in your details
4. Click Next
5. Select "release" build variant
6. Check "V1 (Jar Signature)" and "V2 (Full APK Signature)"
7. Click Finish
8. APK location: `app/release/app-release.apk`

### 5. Install on Android Device

#### Method 1: Direct Install via USB
1. Enable "Developer Options" on your Android device:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
2. Enable "USB Debugging":
   - Go to Settings → Developer Options
   - Enable "USB Debugging"
3. Connect device to computer via USB
4. In Android Studio, click the "Run" button (green triangle)
5. Select your device from the list
6. App will install and launch automatically

#### Method 2: Install APK via File Transfer
1. Copy the APK file to your Android device (via USB or cloud storage)
2. On your device, navigate to the APK file using a file manager
3. Tap the APK file
4. If prompted, enable "Install from Unknown Sources"
5. Tap "Install"
6. Once installed, tap "Open" to launch

#### Method 3: Install via ADB
```bash
adb install app-debug.apk
```

### 6. Verify Installation

1. Look for "Zarif's Car" app icon on your device
2. Launch the app
3. You should see the animated title and car icon
4. Mode switch should be visible
5. Manual control buttons should appear when switching to manual mode

## Troubleshooting

### Build Errors

**Error: "Cannot resolve symbol 'R'"**
- Solution: Clean and rebuild project (Build → Clean Project → Build → Rebuild Project)

**Error: "Failed to resolve: volley"**
- Solution: Check internet connection and sync Gradle again

**Error: "Manifest merger failed"**
- Solution: Check AndroidManifest.xml for correct package name

### Installation Errors

**Error: "App not installed"**
- Solution: Uninstall any previous version and try again

**Error: "Install blocked"**
- Solution: Enable "Install from Unknown Sources" in device settings

**Error: "APK signature verification failed"**
- Solution: For debug builds, this shouldn't happen. For release, ensure keystore is valid

### Runtime Issues

**App crashes on launch**
- Check Logcat in Android Studio for error details
- Verify all resource files are properly copied
- Ensure package name matches in all files

**Buttons not working**
- Verify WiFi connection to "Zarifs Car" hotspot
- Check if ESP8266 is powered and running
- Confirm BASE_URL is set to "http://192.168.4.1"

## App Permissions

The app requires the following permissions (already included in AndroidManifest.xml):
- `INTERNET` - To communicate with ESP8266 web server
- `ACCESS_WIFI_STATE` - To check WiFi connection status
- `CHANGE_WIFI_STATE` - To manage WiFi settings
- `ACCESS_NETWORK_STATE` - To verify network connectivity

## Testing Checklist

- [ ] App installs successfully
- [ ] Title "ZARIF'S CAR" appears with animation
- [ ] Car icon is visible and animated
- [ ] Status shows "Mode: AUTO" by default
- [ ] Manual mode switch works
- [ ] Manual control panel appears when switching to manual
- [ ] All 4 control buttons respond to touch
- [ ] Timer countdown appears in manual mode
- [ ] Status updates every second
- [ ] App handles disconnection gracefully

## Additional Resources

- **Android Studio**: https://developer.android.com/studio
- **Volley Library**: https://developer.android.com/training/volley
- **Material Design**: https://material.io/design

## App Size
- APK Size: ~2-3 MB (debug build)
- APK Size: ~1-2 MB (release build with proguard)

## Minimum Requirements
- Android 5.0 (Lollipop) or higher
- WiFi capability
- ~10 MB free storage

---

**Build completed successfully!** 🎉

The app is now ready to control Zarif's Robotic Car.
