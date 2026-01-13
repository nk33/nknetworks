
# NK Networks Ltd — Flutter App

This is a complete Flutter project for NK Networks Ltd with:
- WebView loading https://www.nknetworks.co.uk
- WhatsApp and Email contact buttons
- "Get Instant Support" wizard
- Branding with NK Networks, Computer Doctor, and MCP logos

## How to Build and Test

### 1. Install Flutter SDK
Follow [Flutter installation guide](https://docs.flutter.dev/get-started/install) and run:
```
flutter doctor
```

### 2. Get dependencies
```
flutter pub get
```

### 3. Build Debug APK (for testing)
```
flutter build apk --debug
```
APK will be at:
```
build/app/outputs/apk/debug/app-debug.apk
```
Install this on your Android phone.

### 4. Build Release APK
```
flutter build apk --release
```

### 5. Build App Bundle (AAB) for Google Play
```
flutter build appbundle --release
```
Upload the .aab file to Google Play Console.

### 6. iOS Build
Open the project in Xcode and archive for App Store submission.

## Notes
- WhatsApp number: 447801866445
- Email: nick@nknetworks.co.uk
- Ensure AndroidManifest.xml has INTERNET permission.
