# Quick Icon Generation Script
# This script helps convert SVG to PNG and generate launcher icons

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  App Icon Generation          " -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = "d:\Zarif-s_Robotic_Car\FlutterApp"
Set-Location $projectPath

# Check if SVG exists
$svgPath = "assets\images\app_icon.svg"
$pngPath = "assets\images\app_icon.png"

if (-not (Test-Path $svgPath)) {
    Write-Host "❌ SVG file not found: $svgPath" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Found SVG icon file" -ForegroundColor Green
Write-Host ""

# Check if PNG already exists
if (Test-Path $pngPath) {
    Write-Host "✅ PNG icon already exists: $pngPath" -ForegroundColor Green
} else {
    Write-Host "⚠️  PNG icon not found. Please convert SVG to PNG:" -ForegroundColor Yellow
    Write-Host "   1. Go to: https://cloudconvert.com/svg-to-png" -ForegroundColor White
    Write-Host "   2. Upload: $svgPath" -ForegroundColor White
    Write-Host "   3. Set size: 512x512" -ForegroundColor White
    Write-Host "   4. Download and save as: $pngPath" -ForegroundColor White
    Write-Host ""
    
    $response = Read-Host "Have you created the PNG file? (y/n)"
    if ($response -ne 'y') {
        Write-Host "Please create the PNG file first, then run this script again." -ForegroundColor Yellow
        exit 0
    }
}

# Check if PNG exists now
if (-not (Test-Path $pngPath)) {
    Write-Host "❌ PNG file still not found: $pngPath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Installing flutter_launcher_icons package..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to get dependencies!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Generating launcher icons..." -ForegroundColor Yellow
flutter pub run flutter_launcher_icons

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "  ✅ Success!                   " -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Your custom car icon has been generated!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Run: flutter clean" -ForegroundColor Cyan
    Write-Host "2. Run: flutter build apk --release" -ForegroundColor Cyan
    Write-Host "3. Install APK and check the new icon!" -ForegroundColor Cyan
} else {
    Write-Host "❌ Failed to generate icons!" -ForegroundColor Red
    Write-Host "Please check the error messages above." -ForegroundColor Yellow
}
