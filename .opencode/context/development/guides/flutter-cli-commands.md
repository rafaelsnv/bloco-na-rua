<!-- Context: development/guides/flutter-cli-commands | Priority: medium | Version: 1.0 | Updated: 2026-07-03 -->

# Flutter CLI Commands — Quick Reference

> Common Flutter / Dart commands used in mobile and desktop app development.

---

## Code Generation (build_runner)

```bash
# One-shot regen after editing annotated files (freezed, json_serializable, retrofit)
dart run build_runner build --delete-conflicting-outputs

# Continuous regen during development
dart run build_runner watch --delete-conflicting-outputs
```

> Use `--delete-conflicting-outputs` whenever generated files conflict with existing hand-written code.

---

## Devices & Run

```bash
# List available devices (emulators and physical)
flutter devices

# Run on a specific device
flutter run -d <device-id>

# Run in release mode (faster, no hot reload)
flutter run --release -d <device-id>
```

---

## Testing & Static Analysis

```bash
# Run all tests
flutter test

# Run a single test file
flutter test test/path/to/specific_test.dart

# Run tests matching a name pattern
flutter test --plain-name "my feature"

# Static analysis
flutter analyze

# Dart-only analyzer
dart analyze

# Apply automatic fixes
dart fix --apply

# Format code
dart format .
```

---

## Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires macOS + Xcode)
flutter build ios --release

# Web (if enabled)
flutter build web --release

# Specific platforms when supported
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

---

## Driver / E2E (Integration Tests)

```bash
# Run an integration_test driver
flutter drive --driver=test_driver/integration_test.dart --target=lib/main.dart

# Newer recommended approach (integration_test package)
flutter test integration_test/
```

---

## Clean & Reset

```bash
# Clean build artifacts
flutter clean

# Re-fetch dependencies
flutter pub get
dart pub get

# Check for outdated dependencies
flutter pub outdated
```

---

## Tips

- **Emulator localhost**: Android emulator uses `10.0.2.2` as a host loopback alias. iOS simulator uses `localhost`. Physical devices need your LAN IP.
- **Hot reload**: `r` in the running terminal reloads code; full restart is `R`.
- **Device short IDs**: `flutter devices --machine` outputs JSON with full device IDs; copy them from there.

---

## Related Files

- Flutter widget lifecycle: `flutter-widget-lifecycle.md`
- Flutter performance: `flutter-performance.md`
- Flutter DI: `flutter-di.md`
- Other Flutter guides: `navigation.md`
