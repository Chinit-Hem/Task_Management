# Firebase + GitHub Fix Plan

## Steps

- [ ] 1. Fix `android/app/google-services.json` — update package name to `com.example.taskmanagement`
- [ ] 2. Add `firebase_core` to `pubspec.yaml`
- [ ] 3. Add `google-services` plugin to `android/settings.gradle.kts`
- [ ] 4. Apply `google-services` plugin in `android/app/build.gradle.kts`
- [ ] 5. Add `Firebase.initializeApp()` to `lib/main.dart`
- [ ] 6. Update `.gitignore` to exclude sensitive files
- [ ] 7. Run `flutter pub get`
- [ ] 8. Rebuild APK
- [ ] 9. Push to GitHub: https://github.com/Chinit-Hem/Task_Management.git
