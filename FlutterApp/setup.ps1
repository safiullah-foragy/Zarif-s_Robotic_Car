# Flutter Project Setup Script
# Run this script in PowerShell to complete the Flutter project setup

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  Zarif's Car - Flutter Setup  " -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is installed
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
$flutterInstalled = Get-Command flutter -ErrorAction SilentlyContinue

if (-not $flutterInstalled) {
    Write-Host "❌ Flutter is not installed!" -ForegroundColor Red
    Write-Host "Please install Flutter from: https://docs.flutter.dev/get-started/install" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Flutter found!" -ForegroundColor Green
Write-Host ""

# Navigate to Flutter project directory
$projectPath = "d:\Zarif-s_Robotic_Car\FlutterApp"
Write-Host "Navigating to: $projectPath" -ForegroundColor Yellow
Set-Location $projectPath

# Run Flutter doctor
Write-Host ""
Write-Host "Running Flutter doctor..." -ForegroundColor Yellow
flutter doctor

# Get Flutter dependencies
Write-Host ""
Write-Host "Getting Flutter dependencies..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependencies installed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to install dependencies!" -ForegroundColor Red
    exit 1
}

# Check for connected devices
Write-Host ""
Write-Host "Checking for connected devices..." -ForegroundColor Yellow
flutter devices

# Clean build
Write-Host ""
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
flutter clean

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!              " -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Connect your Android device or start an emulator" -ForegroundColor White
Write-Host "2. Run: flutter run" -ForegroundColor Cyan
Write-Host "   OR" -ForegroundColor White
Write-Host "3. Build APK: flutter build apk --release" -ForegroundColor Cyan
Write-Host ""
Write-Host "Happy coding! 🚗💨" -ForegroundColor Green
