<!-- Context: project-intelligence/lookup/ui-organization | Priority: medium | Version: 1.1 | Updated: 2026-11-19 -->

# UI Organization

**Quick Reference**: Shared widgets organized by type.

---

## Widget Folders

```
lib/src/shared/widgets/
├── buttons/       # Reusable button components
├── cards/         # Card components (info, table, selection)
├── charts/        # Chart widgets (line, column)
├── dialogs/       # Modal dialogs
├── forms/         # Form-related widgets
├── modals/        # Modal containers
├── sidebar/       # Sidebar components
└── top_bar/       # Top bar with navigation
```

---

## App Core Widgets (lib/ui/core/widgets/)

```
lib/ui/core/widgets/
├── inputs/      # app_date_time_field.dart — ONLY date/time input widget
├── layout/      # content_width_limiter.dart — caps width at Spacing.maxContentWidth (720)
├── state/       # AppStateView + compact AppError/AppEmpty variants
├── buttons/     # AppButton / AppIconButton / AppFAB (48dp touch targets)
└── ...
```

## Localization Assets

| Path | Notes |
|------|-------|
| `lib/l10n/` | ARB source of truth (`app_pt.arb`, `app_en.arb`) + generated files — NEVER hand-edit generated files (`flutter gen-l10n`) |
| `lib/core/date_format.dart` | Locale helpers: kAppLocale, formatDateTime, formatShortDate, etc. |

See `../concepts/localization.md` for the i18n pattern.

---

## Typography

| Family | Usage |
|--------|-------|
| PrimaryHeading | Headings |
| PrimaryBody | Body text |
| DisplayHeading | Special headings |
| SystemFallback | Fallback |

---

## Related

- `core/standards/examples/widget-pattern.md` — base widget patterns
- `project-intelligence/lookup/` — other project-specific conventions
