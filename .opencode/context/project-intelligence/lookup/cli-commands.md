<!-- Context: project-intelligence/lookup/cli-commands | Priority: medium | Version: 3.1 | Updated: 2026-07-08 -->

# CLI Commands — BlocoNaRua (Mobile)

**Quick reference**: Common development commands for this mobile Flutter project.

## Code Generation

```bash
# After editing a freezed entity
dart run build_runner build --delete-conflicting-outputs

# Continuous regen during dev (optional)
dart run build_runner watch --delete-conflicting-outputs
```

## Build & Run (Mobile)

```bash
# List devices
flutter devices

# Run on Android (emulator)
flutter run -d <android-device-id>

# Run on iOS (simulator, macOS only)
flutter run -d <ios-device-id>

# Run all tests
flutter test

# Static analysis
flutter analyze
dart analyze

# Build release APK
flutter build apk --release

# Build release App Bundle (Play Store)
flutter build appbundle --release

# Build iOS (macOS only, requires Xcode)
flutter build ios --release
```

## Driver / E2E Tests

```bash
# Run integration tests (uses lib/driver_main.dart as entry)
flutter drive --driver=test_driver/integration_test.dart --target=lib/driver_main.dart
```

## Backend / Environment

```bash
# Copy .env.example -> .env if missing (NEVER commit .env)
cp .env.example .env

# Edit .env with:
#   SUPABASE_URL=https://<your>.supabase.co
#   SUPABASE_ANON_KEY=<key>
#   API_URL=http://10.0.2.2:8080  # Android emulator alias for host
```

> `10.0.2.2` is Android emulator's localhost alias. iOS simulator uses `localhost`. Real device: use your LAN IP.

## Common Aliases (optional)

```bash
alias bnrun='flutter run -d <device-id>'         # quick run
alias bnbuild='flutter build apk --release'       # release build
alias bnfreezed='dart run build_runner build --delete-conflicting-outputs'
```

## Task-Management CLI (`.opencode/skills/task-management/`)

> ⚠️ **Tooling note (since 2026-07-08)**: `router.sh` **silently fails** to update `subtask_NN.json` `status` field (npx / ts-node invocation issue). JSON `status` must be updated **manually** (edit the JSON file directly) when delegating through `BatchExecutor` / `CoderAgent`. Don't rely on the CLI auto-update.

```bash
# Validate batch completion (this works; reads JSON status)
bash .opencode/skills/task-management/router.sh status <feature-slug>

# Where <feature-slug> corresponds to .tmp/tasks/<feature-slug>/
# Output: "X/Y tasks completed" — based on JSON status, NOT CLI-side tracking
```

Historical subtask JSONs are archived at `.tmp/.archive/2026-07-08/tasks/` for reference.

## Related

- `concepts/stack.md` — package versions
- `concepts/device-types.md` — supported devices
- `mcp-tools-dart.md` — Dart MCP server tools
- `lookup/routes.md` — route shorthand
