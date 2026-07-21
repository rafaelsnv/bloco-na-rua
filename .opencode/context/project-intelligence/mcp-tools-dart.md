<!-- Context: project-intelligence/mcp-tools-dart | Priority: high | Version: 3.1 | Updated: 2026-07-02 -->

# Dart MCP Tools — BlocoNaRua

**Purpose**: Flutter dev workflow via Dart Tooling Daemon (DTD). Notes project-specific to mobile targets.

## Quick Reference

| Tool | Purpose |
|------|---------|
| `dart_mcp_launch_app` | Launch Flutter app, returns DTD URI |
| `dart_mcp_list_devices` | List available devices |
| `dart_mcp_hot_reload` | Apply code changes without restart |
| `dart_mcp_hot_restart` | Reset state and reload |
| `dart_mcp_get_widget_tree` | Inspect widget hierarchy |
| `dart_mcp_run_tests` | Run Flutter/Dart tests |
| `dart_mcp_analyze_files` | Check for errors |

> The exact tool set may vary depending on the Dart/Flutter MCP server version.

## Project-Specific Notes

This project is **mobile-only** (Android + iOS). For device specs, see `concepts/device-types.md`.

- **Target device**: Use `flutter_devices` to find Android emulator/iOS simulator
- **E2E entry**: For Flutter Driver tests, use `dart_mcp_launch_app` with `target: "lib/driver_main.dart"` (not `main.dart`)
- **Theme verification**: `lib/ui/core/theme/bloco_na_rua_theme.dart` (light + dark)

## Launch App (project-specific)

```javascript
dart_mcp_launch_app({
  device: "<device-id>",          // Android emulator or iOS simulator
  root: "C:/Repos/bloco_na_rua",   // NO file:// prefix!
  target: "lib/main.dart",         // Default
})
```

## Workflow Sequences

### Standard Development
```
1. dart_mcp_list_devices → find device (Android emulator default)
2. dart_mcp_launch_app → get DTD URI
3. Make code changes
4. dart_mcp_hot_reload → apply (preserves state)
5. If reload didn't catch → dart_mcp_hot_restart (resets state)
```

### Run Tests
```
1. dart_mcp_run_tests → run all tests
2. If failure → dart_mcp_get_runtime_errors
```

## Common Errors

| Error | Fix |
|-------|-----|
| "Failed to connect to DTD" | NO `file://` prefix in `launch_app` |
| "Device not found" | Run `dart_mcp_list_devices` |
| "Hot reload not applying" | Use `dart_mcp_hot_restart` |
| "Widget tree empty" | Ensure app is running |

## Usage

AI agents should use these when:
- User asks to "run", "launch", "start" Flutter app
- User asks to "test" or "run tests"
- Debugging UI issues (get widget tree)
- After making code changes (hot reload/restart)

**Note**: Replace device-id with actual values from your environment. Default is usually an Android emulator.
