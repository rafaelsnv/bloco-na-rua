<!-- Context: development/guides/flutter-naming-conventions | Priority: medium | Version: 1.0 | Updated: 2026-07-03 -->

# Flutter / Dart Naming Conventions — Quick Reference

> Universal Dart language conventions plus common Flutter project conventions. Follow these unless your project has an explicit override.

---

## Identifier Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | `snake_case.dart` | `home_cubit.dart` |
| Folders | `snake_case` (Dart convention) or `camelCase` (project choice) | `home_feature`, `carnival_block` |
| Classes | `PascalCase` | `HomeCubit` |
| Abstract classes / interfaces | `PascalCase` (some projects use `I` prefix for interfaces) | `IRepository`, `Repository` |
| Type aliases for unions | `PascalCase` + suffix | `HomeStatus`, `EntityState` |
| Enum values | `camelCase` | `HomeStatus.loading` |
| Extensions | `PascalCase` on `Extension` | `StringExtensions` |
| Variables, parameters | `camelCase` | `userCount` |
| Top-level / class constants | `camelCase` (Dart style; no `k` prefix) | `baseOptions`, `defaultTimeout` |
| Private fields / methods | `_camelCase` | `_membersRepo`, `_loadCached()` |
| Route constants | `<Project>.x` (PascalCase class + camelCase members) | `Routes.userMeetings`, `AppRoutes.home` |
| Route path params | `camelCase` (with colon) | `:blockId`, `:userId` |
| Routes (URL paths) | `kebab-case` segments | `/`, `/login`, `/meeting-presences` |

---

## Quote Style

Use double quotes in Dart: `"text"` — not `'text'`.

This is enforced by `dart_style` for many projects via `analysis_options.yaml`:

```yaml
linter:
  rules:
    prefer_single_quotes: true   # OR prefer_double_quotes: true
```

Pick one and enforce it project-wide.

---

## Class Member Ordering (Recommended)

```dart
class MyClass extends BaseClass with Mixin {
  // 1. Static const fields
  static const int maxItems = 100;

  // 2. Instance fields
  final String name;
  final int _count;

  // 3. Constructors
  const MyClass({required this.name, int count = 0}) : _count = count;

  // 4. Factory constructors
  factory MyClass.fromJson(Map<String, dynamic> json) => ...;

  // 5. Static methods
  static MyClass create() => MyClass(name: '');

  // 6. Instance getters/setters
  bool get isEmpty => _count == 0;

  // 7. Public methods (then protected, then private)
  void increment() => ...
  void _internal() => ...

  // 8. Operator overloads (rare)
  @override bool operator ==(other) => ...

  // 9. Overrides last (build, copyWith, etc.)
  @override Widget build(BuildContext context) => ...
}
```

---

## Anti-Patterns to Avoid

| Pattern | Why it's wrong |
|---------|----------------|
| `kConstantName` | Dart style guide explicitly avoids the `k` prefix |
| `HomeCubitState` class for state | Use `HomeState` — the cubit name + the suffix is redundant |
| `String _s` / `int _n` | Field names should describe meaning, not type |
| `home_cubit_state.dart` for a state file | Prefer `home_state.dart` to keep files paired with their cubit |
| Inconsistent case in same project | Choose once and apply uniformly |

---

## Related Files

- Dart language standards: `../../core/standards/dart.md`
- Flutter state patterns: `../concepts/flutter-state-management.md`
- Code-quality standards: `../../core/standards/code-quality.md`
