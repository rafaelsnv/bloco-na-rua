# Flutter & Dart Analyzer

**Priority**: Critical · **Version**: 1.1 · **Updated**: 2026-07-01

---

## Quick Reference

| Level | Severity | Action |
|-------|----------|--------|
| Error | 🔴 High | Must fix — code won't compile |
| Warning | 🟡 Medium | Should fix — may cause runtime issues |
| Info | 🟢 Low | Style suggestion |

---

## analysis_options.yaml Structure

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude: [lib/src/i18n/**, lib/**.g.dart, build/, .dart_tool/]
  errors:
    avoid_empty_else: error
    dead_code: error
    cancel_subscriptions: error   # memory leaks
    unawaited_futures: error       # async bugs
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
    always_declare_return_types: true
    prefer_final_fields: true
    use_super_parameters: true
```

### Severity Levels

| Setting | Behavior |
|---------|----------|
| `error` | Compilation fails |
| `warning` | Build continues |
| `info` | Informational |
| `ignore` | Suppressed |

---

## Common Issues & Fixes

### Errors (must fix)

| Issue | Fix |
|-------|-----|
| `undefined_method` | Add method or change access |
| `invalid_assignment` | Cast types properly |
| `non_abstract_class_inherits_abstract_member` | Implement abstract method |
| `missing_return` | Add return or change to `void` |
| `unnecessary_statements` | Remove dead code |

### Warnings

| Issue | Fix |
|-------|-----|
| `unused_element` | Remove or add `// ignore: unused_element` |
| `unused_import` | Remove import |
| `prefer_final_*` | Add `final` |
| `discarded_futures` | Use `await` or `unawaited()` |
| `dead_code` | Remove unreachable code |

### Info (style)

| Issue | Fix |
|-------|-----|
| `prefer_initializing_formals` | Use `this.field` in constructor |
| `use_super_parameters` | Use `super.field` |
| `always_put_control_body_on_new_line` | Expand single-line `if` |

---

## Template Method Pattern: Private Members

Private members (`_name`) are library-scoped. When subclass overrides a private member from base class library, analyzer reports false `unused_element`:

```dart
// ❌ False positive
abstract class PdfTemplateService<T> {
  String get _serviceName;
}
class SamplingPumpPdfService extends PdfTemplateService {
  @override
  String get _serviceName => 'SamplingPumpPdf';  // unused_element
}

// ✅ Suppress with explanation
// ignore: unused_element
// Private member used by base class via template method
String get _serviceName => 'SamplingPumpPdf';
```

---

## Suppression Syntax

```dart
// Per-file
// ignore_for_file: unused_local_variable, dead_code

// Per-line
int x = ''; // ignore: invalid_assignment

// Inline with reason
// ignore: unused_element (template method)
String get _name => 'x';
```

**Rule**: Always include a reason explaining *why* you're ignoring.

---

## Key Flutter Linter Rules

| Rule | Why |
|------|-----|
| `avoid_print` | No print in production |
| `prefer_const_constructors` | Performance |
| `use_key_in_widget_constructors` | Widget identity |
| `avoid_unnecessary_containers` | Layout efficiency |
| `cancel_subscriptions` | Prevent memory leaks |

**Recommended sets**: `flutter_lints` > `lints/recommended` > `lints/core`.

---

## Best Practices

**Always**: run `dart analyze` before commit · fix errors immediately · explain every `// ignore:`.

**Never**: commit code with errors · leave `print()` in production · use `// ignore:` without reason.

---

## Recommended Custom Severities

| Rule | Severity | Reason |
|------|----------|--------|
| `avoid_empty_else` | error | Logic bugs |
| `always_use_package_imports` | error | Relative imports cause issues |
| `cancel_subscriptions` | error | Memory leaks |
| `dead_code` | error | Clean code |
| `unnecessary_statements` | error | Bugs |
| `unawaited_futures` | error | Async bugs |
| `iterable_contains_unrelated_type` | error | Type safety |
| `list_remove_unrelated_type` | error | Type safety |
| `no_duplicate_case_values` | error | Switch bugs |
| `flutter_style_todos` | warning | TODO consistency |
| `prefer_final_fields` | warning | Immutability |
| `file_names` | warning | Naming convention |

---

## Resources

- [Dart Analyzer](https://dart.dev/tools/analysis) · [Linter Rules](https://dart.dev/tools/linter-rules) · [Effective Dart](https://dart.dev/effective-dart)
