
# NK Networks Ltd — Flutter App

This source bundle includes the `lib/` code, `pubspec.yaml`, and `assets/` for an app that:

- Loads https://www.nknetworks.co.uk in a WebView
- Lets users contact you via WhatsApp and Email
- Provides a step-by-step "Get Instant Support" flow that builds a pre-filled message

## Quick Start (Fastest way to get an APK for testing)

1) Make sure Flutter SDK is installed: https://docs.flutter.dev/get-started/install
2) Create a fresh Flutter project shell:

```bash
flutter create nk_networks_app
```

3) Replace the generated files with the contents of this zip:

- Overwrite the new project's `lib/` with the `lib/` from this zip
- Overwrite the project's `pubspec.yaml` with the one in this zip
- Copy the `assets/` folder into the project root

4) Fetch packages:

```bash
cd nk_networks_app
flutter pub get
```

5) (Android only) Build a debug APK for quick install:

```bash
flutter build apk --debug
```

The APK will be at `build/app/outputs/apk/debug/app-debug.apk` and is debug-signed, so you can install it directly on your device.

6) (Android for Play Store) Build an App Bundle (AAB):

```bash
flutter build appbundle --release
```

Upload the resulting `.aab` to Google Play Console.

7) (iOS) Open the project in Xcode to archive and upload via Organizer or Transporter.

## Android Manifest notes

Ensure your `android/app/src/main/AndroidManifest.xml` contains:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.nknetworks.app">
    <uses-permission android:name="android.permission.INTERNET" />

    <!-- Optional: visibility config for URL schemes on Android 11+ -->
    <queries>
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="https" />
        </intent>
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="mailto" />
        </intent>
    </queries>

    <application
        android:label="NK Networks Ltd"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTask"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <meta-data android:name="flutterEmbedding" android:value="2" />
    </application>
</manifest>
```

## iOS Info.plist notes

Add the following to `ios/Runner/Info.plist` to declare URL schemes:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>mailto</string>
</array>
```

This helps when checking for URL handling in `url_launcher`.

## Branding assets

- `assets/images/Canva logo 4.png` — NK Networks Ltd primary logo
- `assets/images/comp doc final e card.jpg` — Computer Doctor sub-brand
- `assets/images/mcp logo.png` — Microsoft Certified Professional badge

## Notes

- WhatsApp number is formatted as `447801866445` for wa.me links.
- The support flow lets users send via WhatsApp **and** Email.

