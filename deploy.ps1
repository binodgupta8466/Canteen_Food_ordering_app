# ==============================================================================
# CampusBite Canteen App - Automated Deployment Script
# ==============================================================================

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " CampusBite Canteen - Deployment Script    " -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Check for Flutter
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Write-Host "[1/3] Fetching dependencies..." -ForegroundColor Green
    flutter pub get
    
    Write-Host "[2/3] Building Web production bundle..." -ForegroundColor Green
    flutter build web --release
} else {
    Write-Host "[!] Flutter CLI was not found in PATH." -ForegroundColor Yellow
    Write-Host "    Make sure Flutter SDK is installed and added to your environment PATH." -ForegroundColor Yellow
}

# 2. Check for Firebase CLI
if (Get-Command firebase -ErrorAction SilentlyContinue) {
    Write-Host "[3/3] Deploying to Firebase Hosting & Firestore rules..." -ForegroundColor Green
    firebase deploy --only hosting,firestore:rules
} else {
    Write-Host "`n[i] Firebase CLI is not installed or not in PATH." -ForegroundColor Cyan
    Write-Host "    To install Firebase CLI, run:" -ForegroundColor White
    Write-Host "    npm install -g firebase-tools`n" -ForegroundColor Yellow
    Write-Host "    Then run:" -ForegroundColor White
    Write-Host "    firebase login" -ForegroundColor Yellow
    Write-Host "    firebase deploy --only hosting,firestore:rules" -ForegroundColor Yellow
}

Write-Host "`nDeployment preparation complete!" -ForegroundColor Green
