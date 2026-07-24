---
provenance: bilbos.Desktop.Main
contaminated: true
audit_date: 2026-07-01
---

<!-- Context: project-intelligence/concepts/stack | Priority: critical | Version: 1.0 | Updated: 2026-05-04 -->

# Tech Stack - Flutter Desktop

**Core Concept**: Flutter Desktop with Cubit/BLoC state management and modular DI.

---

## Primary Stack

| Layer | Technology | Version | Notes |
|-------|------------|---------|-------|
| Framework | Flutter Desktop | (latest stable) | Windows / macOS / Linux app |
| Language | Dart | (latest stable, null-safe) | Required for sound null safety |
| State | flutter_bloc (Cubit) | (latest stable) | BLoC/Cubit pattern |
| DI | flutter_modular OR get_it | (latest stable) | Service locator |
| Local Storage | hive + hive_flutter OR shared_preferences | (latest stable) | NoSQL / key-value |
| Charts | syncfusion_flutter_charts OR fl_chart | (latest stable) | Data viz |
| PDF | syncfusion_flutter_pdf OR pdf package | (latest stable) | Reports |

> **Note**: This is a generic template. Replace placeholder versions with versions pinned in your project's `pubspec.yaml`.

---

## Key Dependencies

| Library | Purpose |
|---------|---------|
| `equatable` | Immutable state |
| `json_annotation` + `json_serializable` | Code generation |
| `intl` | i18n |
| `reactive_forms` OR `flutter_form_builder` | Form validation |
| `bitsdojo_window` OR `window_manager` | Custom window chrome |

---

## Reference

- Full dependencies: `pubspec.yaml`
- Code standards: `core/standards/`
