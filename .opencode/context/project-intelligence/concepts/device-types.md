<!-- Context: project-intelligence/concepts/device-types | Priority: high | Version: 1.0 | Updated: 2026-05-04 -->

# Device Types - Modular Architecture

**Core Concept**: Multiple device types for industrial test equipment. Each has its own module with test adapter, cubit, and pages.

---

## Device Types

| Device | Enum Value | Module Path |
|--------|-----------|-------------|
| Device A | `deviceA` | `lib/src/modules/device_a/` |
| Device B | `deviceB` | `lib/src/modules/device_b/` |
| Device C | `deviceC` | `lib/src/modules/device_c/` |
| Device D | `deviceD` | `lib/src/modules/device_d/` |

---

## Per-Device Structure

```
lib/src/modules/{device}/
├── {device}_module.dart              # Module definition
├── domain/models/{device}_model.dart # Main model
├── core/adapters/{device}_test_adapter.dart
└── ui/
    ├── cubit/{device}_cubit.dart
    ├── home/{device}_home_page.dart
    ├── info/{device}_info_page.dart
    ├── tests/{device}_tests_page.dart
    └── reports/{device}_reports_page.dart
```

---

## Pages

| Page | Route | Purpose |
|------|-------|---------|
| Home | `/home` | Device overview + quick actions |
| Info | `/info` | Device details + settings |
| Tests | `/tests` | Test execution + history |
| Reports | `/reports` | Report generation + export |

---

## Reference

- Adding new device: `project-intelligence/guides/device-checklist.md`
- Test adapters: `lib/src/core/adapters/`
