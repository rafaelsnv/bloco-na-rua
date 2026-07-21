<!-- Context: project-intelligence/concepts/bloc-state-pattern | Priority: high | Version: 1.1 | Updated: 2026-07-02 -->

# Bloc State Pattern — Decision Tree

**Core Concept**: Choose the right state representation per layer — **default**: Cubits use plain `Equatable` + `enum Status`, entities use `@freezed sealed`, forms use plain classes. **Exception** (since 2026-07-02): freezed IS allowed for cubits whose state is a sealed union with payload-carrying variants. See `decisions-log.md` §"Plain Class UI States" for the revised decision and audit.

---

## Decision Tree

```
Is it a Domain Entity?
├── YES → @freezed sealed class extends EntityBase (see concepts/freezed-entity.md)
└── NO
    │
    Is it a Cubit UI State?
    ├── YES
    │   ├── State is a single class with a Status enum + nullable data fields?
    │   │   └── YES → Plain class + enum Status + Equatable + copyWith (default)
    │   └── State is a sealed union with payload-carrying variants?
    │       └── YES → @freezed sealed class (exception; see decisions-log.md)
    └── NO
        │
        Is it a Form input state?
        ├── YES → Plain class (one field per input) + per-field validation
        └── NO → Plain class, keep minimal
```

---

## Why Different Shapes Per Layer?

| Layer    | Reason                                                                  |
| -------- | ----------------------------------------------------------------------- |
| Entity   | Codegen gives `copyWith`, `==`, `fromJson`; sealed unions for variants |
| UI State | Plain class is easier to log, debug, reason about; no codegen overhead |
| Form     | Plain class so tests don't depend on equatable hashes                   |

---

## Cubit State Template

```dart
import 'package:equatable/equatable.dart';

enum MyFeatureStatus { initial, loading, success, failure }

class MyFeatureState extends Equatable {
  const MyFeatureState({
    this.status = MyFeatureStatus.initial,
    this.data,
    this.errorMessage,
  });

  final MyFeatureStatus status;
  final MyEntity? data;             // optional payload
  final String? errorMessage;

  MyFeatureState copyWith({
    MyFeatureStatus? status,
    MyEntity? data,
    String? errorMessage,
  }) => MyFeatureState(
    status: status ?? this.status,
    data: data ?? this.data,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, data, errorMessage];
}
```

---

## Pitfalls

| Pitfall                                              | Fix                                              |
| ---------------------------------------------------- | ------------------------------------------------ |
| Forgot to add field to `props` list                   | Test with cubit test that emits twice — silent   |
| Using freezed for a single-state / flat cubit state  | Gratuitous codegen with no benefit; use plain Equatable instead. See decisions-log.md for when freezed IS appropriate. |
| Passing `null` to `copyWith` to "clear"               | Add explicit `clearX()` method instead            |
| Storing Cubit as singleton                            | Use `BlocProvider(create:)` per route             |
| Emitting same state twice                              | Cubit dedupes IF state `==` other state (Equatable) |
| Try/catch inside `Future.wait` vs around it          | Wrap the whole `Future.wait` in try/catch          |
| Mutating state fields directly                         | Always `emit(state.copyWith(...))`                 |

---

## When to Split a State

If a Cubit's state file > 150 lines, split it:
- One state per screen-mode (e.g., `MyFeatureListState`, `MyFeatureDetailState`)
- Use a parent Cubit to dispatch to one of N child cubits

---

## Reference

- `examples/state-pattern.md` — canonical `HomeState`
- `concepts/freezed-entity.md` — entity pattern
- `technical-component-pattern.md` — cubit layer contract
- `lookup/cubits.md` — all cubits
