<!-- Context: project-intelligence/examples/widget-pattern | Priority: high | Version: 2.0 | Updated: 2026-11-17 -->

# Widget Pattern Example

**Core Concept**: Widgets are token-driven. All colors, elevation, spacing, and radii come from the design system in `lib/ui/core/tokens/` — never raw `Colors.white` or `withOpacity`.

---

## Token-Driven Button (AppButton)

```dart
import 'package:bloco_na_rua/ui/core/tokens/app_colors.dart';
import 'package:bloco-na-rua/ui/core/tokens/app_elevation.dart';

ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.inkFor(AppColors.primary), // luminance rule
    elevation: AppElevation.md,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
  ),
  onPressed: onPressed,
  child: Text(label),
)
```

Use the shared `AppButton` component (`lib/ui/core/widgets/buttons/app_button.dart`) instead of re-rolling buttons.

---

## Key Points

1. **Tokens only**: `AppColors`, `AppElevation`, `AppSpacing`, `AppRadius` from `lib/ui/core/tokens/`
2. **`AppColors.inkFor(fill)`** picks ink (text/icon) color by background luminance — never hardcode white/black
3. **Project invariant**: NO raw `Colors.white`, `Colors.black`, or `.withOpacity(...)` — use tokens
4. Theme files in `lib/ui/core/theme/` wire tokens into `ThemeData`
5. Reusable widgets live in `lib/ui/core/widgets/` (e.g. `AppButton`)

---

## Reference

- Tokens: `lib/ui/core/tokens/` (see `lookup/design-tokens.md` for the full map)
- Shared button: `lib/ui/core/widgets/buttons/app_button.dart`
- Theme: `lib/ui/core/theme/`
