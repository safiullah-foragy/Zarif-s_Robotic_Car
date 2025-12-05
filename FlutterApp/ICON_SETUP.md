# App Icon Setup Instructions

## 📱 Using Custom Car Icon for the App

I've created a custom car icon design in `assets/images/app_icon.svg`.

### Automatic Icon Generation (Recommended)

Use the **flutter_launcher_icons** package to automatically generate all icon sizes:

1. **Add dependency to `pubspec.yaml`:**

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#1a237e"
  adaptive_icon_foreground: "assets/images/app_icon.png"
```

2. **Convert SVG to PNG (512x512):**

You can use online tools:
- https://cloudconvert.com/svg-to-png
- https://svgtopng.com/

Or use ImageMagick:
```powershell
magick convert -background none -resize 512x512 app_icon.svg app_icon.png
```

3. **Generate icons:**
```powershell
flutter pub get
flutter pub run flutter_launcher_icons
```

---

## Manual Method (Alternative)

If you prefer manual setup:

### 1. Create PNG versions at different sizes:

| Size | Path |
|------|------|
| 192x192 | `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` |
| 144x144 | `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` |
| 96x96 | `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` |
| 72x72 | `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` |
| 48x48 | `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` |

### 2. Replace default icons in each mipmap folder

---

## Quick Setup with flutter_launcher_icons

1. **Update `pubspec.yaml`:**

Add these lines at the end of the file:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: "launcher_icon"
  ios: false
  image_path: "assets/images/app_icon.png"
  min_sdk_android: 21
  adaptive_icon_background: "#1a237e"
  adaptive_icon_foreground: "assets/images/app_icon.png"
```

2. **Convert SVG to PNG** (save as `app_icon.png` in `assets/images/`)

3. **Run:**
```powershell
flutter pub get
flutter pub run flutter_launcher_icons
```

4. **Rebuild the app:**
```powershell
flutter clean
flutter build apk --release
```

---

## Icon Design Features

✅ Blue gradient background (matches app theme)
✅ Orange/red car illustration
✅ "ZC" text (Zarif's Car initials)
✅ Wheels, windows, lights
✅ Modern Material Design style
✅ High contrast for visibility

---

## Testing the Icon

After setting up:
1. Install APK on device
2. Check home screen for new icon
3. Verify icon appears in app drawer
4. Test on different Android versions

---

## Tools for SVG to PNG Conversion

**Online:**
- https://cloudconvert.com/svg-to-png
- https://svgtopng.com/
- https://convertio.co/svg-png/

**Desktop:**
- Adobe Illustrator
- Inkscape (free)
- GIMP (free)

**Command Line:**
- ImageMagick: `magick convert app_icon.svg app_icon.png`
- Inkscape CLI: `inkscape app_icon.svg -o app_icon.png -w 512 -h 512`

---

Your custom car icon is ready to use! 🚗🎨
