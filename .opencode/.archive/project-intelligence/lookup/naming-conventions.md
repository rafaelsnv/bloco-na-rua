<!-- Context: project-intelligence/lookup/naming-conventions | Priority: medium | Version: 1.0 | Updated: 2026-05-04 -->

# Naming Conventions - Flutter/Dart

**Quick Reference**: File, class, and variable naming rules.

---

## Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | snake_case.dart | `feature_cubit.dart` |
| Classes | PascalCase | `FeatureCubit` |
| State classes | PascalCase + State | `FeatureState` |
| State variants | sealed + final | `FeatureLoaded` |
| Models | PascalCase + Model | `FeatureModel` |
| Folders | snake_case | `feature_module/` |
| Variables | camelCase | `featureId` |
| Constants | camelCase + k | `kDefaultTimeout` |
| Private | _prefix | `_featureService` |
| Quotes | Double | `"text"` not `'text'` |
