# RupeeTrack — first-time project setup
$ErrorActionPreference = "Stop"

$flutter = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutter) {
    Write-Host "Flutter not found in PATH."
    Write-Host "Install from https://docs.flutter.dev/get-started/install"
    Write-Host "Then re-run this script."
    exit 1
}

if (-not (Test-Path "android")) {
    Write-Host "Creating Flutter platform projects..."
    flutter create . --org com.viswajith --project-name rupee_track
}

Write-Host "Fetching dependencies..."
flutter pub get

Write-Host "Running code generation (Drift + Freezed)..."
dart run build_runner build --delete-conflicting-outputs

Write-Host ""
Write-Host "Setup complete. Run: flutter run"
