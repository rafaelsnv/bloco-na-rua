---
provenance: bilbos.Desktop.Main
contaminated: true
audit_date: 2026-07-01
---

<!-- Context: project-intelligence/mcp-tools-dart | Priority: high | Version: 1.1 | Updated: 2026-05-06 -->

# Dart MCP Tools

**Purpose**: Flutter development workflow via Dart Tooling Daemon (DTD)

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

> The exact tool set may vary depending on the Dart/Flutter MCP server version available. Use this as a general pattern; refer to the MCP server's own docs for the current tool list.

## Launch App

```javascript
dart_mcp_launch_app({
  device: "<device-id>",          // From dart_mcp_list_devices
  root: "path/to/project",         // NO file:// prefix!
  target: "lib/main.dart"         // Entry point
})
// Returns: DTD URI for dart_mcp_connect_dart_tooling_daemon
```

## Workflow Sequences

### Standard Development
```
1. dart_mcp_list_devices → find device
2. dart_mcp_launch_app → get DTD URI
3. Make code changes
4. dart_mcp_hot_reload → apply changes
5. If changes missed → dart_mcp_hot_restart
```

### Run Tests
```
1. dart_mcp_add_roots (if not set)
2. dart_mcp_run_tests → run all tests
3. If failure → dart_mcp_get_runtime_errors
```

## Common Errors

| Error | Fix |
|-------|-----|
| "Failed to connect to DTD" | NO file:// prefix in launch_app |
| "Device not found" | Run dart_mcp_list_devices |
| "Hot reload not applying" | Use dart_mcp_hot_restart |
| "Widget tree empty" | Ensure app is running |

## Usage

AI agents should use these when:
- User asks to "run", "launch", "start" Flutter app
- User asks to "test" or "run tests"
- Debugging UI issues (get widget tree)
- After making code changes (hot reload/restart)

**Note**: Replace `path/to/project` and `device-id` with actual values from your environment.
