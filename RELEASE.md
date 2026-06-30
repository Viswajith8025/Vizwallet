# Release build checklist

## 1. Android signing

1. Create a release keystore (once):
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Copy `android/key.properties.example` → `android/key.properties`
3. Fill in store path, passwords, and alias
4. **Never commit** `key.properties` or `*.jks`

## 2. Launcher icons

1. Add `assets/icon/icon.png` (1024×1024) and `assets/icon/icon_foreground.png`
2. Run: `dart run flutter_launcher_icons`
3. Commit generated `android/app/src/main/res/mipmap-*` files

## 3. Groq API (AI Jithu)

Release builds **do not** embed `groq_local.dart` keys. Inject at build time:

```bash
flutter build appbundle --dart-define=GROQ_API_KEY=your_server_proxy_key
```

For production, prefer a Supabase Edge Function proxy instead of client keys.

## 4. Play Store

- Host `PRIVACY.md` and `TERMS.md` (or your own URLs) and update `AppConstants.privacyPolicyUrl`
- Complete Data Safety form (financial data, microphone, AI third-party)
- Build: `flutter build appbundle --release`
