<!-- Context: project-intelligence/examples/module-pattern | Priority: high | Version: 1.0 | Updated: 2026-05-04 -->

# Module Pattern Example

**Example**: flutter_modular Module for feature areas.

---

## Module Definition

```dart
class FeatureModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.lazySingleton<FeatureCubit>((i) => FeatureCubit(
      featureService: i<IFeatureService>(),
      dataService: i<IDataService>(),
      exportService: i<IExportService>(),
    )),
  ];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute("/feature", module: FeatureModule(), children: [
      ModuleRoute("/home", module: FeatureModule()),
      ModuleRoute("/info", module: FeatureModule()),
      ModuleRoute("/data", module: FeatureModule()),
      ModuleRoute("/reports", module: FeatureModule()),
    ]),
  ];
}
```

---

## Key Points

1. `Bind.lazySingleton` for Cubit injection
2. `i<T>()` to get injected dependencies
3. `ModuleRoute` with child routes for each page
4. Children routes are relative to parent

---

## Reference

- Full example: `lib/src/modules/{feature}/{feature}_module.dart`
