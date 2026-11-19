<!-- Context: project-intelligence/guides/feature-checklist | Priority: high | Version: 1.0 | Updated: 2026-05-04 -->

# Adding New Feature - Checklist

**Guide**: Steps to add a new feature module to a Flutter desktop application.

---

## Step 1: Create Module Structure

Create directory: `lib/src/modules/{feature_name}/`
- `{feature_name}_module.dart`
- `domain/models/{feature_name}_model.dart`
- `core/adapters/{feature_name}_adapter.dart`
- `core/services/{feature_name}_service.dart`
- `ui/cubit/{feature_name}_cubit.dart`
- `ui/cubit/{feature_name}_state.dart`
- `ui/home/{feature_name}_home_page.dart`
- `ui/info/{feature_name}_info_page.dart`
- `ui/data/{feature_name}_data_page.dart`
- `ui/reports/{feature_name}_reports_page.dart`

---

## Step 2: Update Core Files

| # | File |
|---|------|
| 1 | `lib/src/domain/enums/feature_type_enum.dart` |
| 2 | `lib/src/core/adapters/feature_adapter.dart` |
| 3 | `lib/src/core/adapters/data_adapter.dart` |
| 4 | `lib/src/core/services/feature_service.dart` |
| 5 | `lib/src/domain/converters/feature_converter.dart` |
| 6 | `lib/src/modules/features/bloc/feature_cubit.dart` |

---

## Step 3: Generate Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Step 4: Test

Run the app and verify the new feature module loads correctly.

---

## Reference

- Module template: `project-intelligence/examples/module-pattern.md`
- Model template: `project-intelligence/examples/model-pattern.md`
