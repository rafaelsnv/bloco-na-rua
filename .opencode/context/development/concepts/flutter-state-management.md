<!-- Context: development/concepts/flutter-state-management | Priority: high | Version: 2.2 | Updated: 2026-07-03 -->

# Flutter State Management Patterns

> Universal Flutter state management patterns — applicable across any Flutter project.

## Quick Reference

| Pattern | When to Use | Key Benefit |
|---------|-------------|-------------|
| id-Based Lookup | Object in list may be replaced with modified copy | Stable identity regardless of property changes |
| Child-to-Parent Callbacks | Parent passes callback to child for state updates | Unidirectional data flow |
| Cubit + Sealed State | Cubit UI state is a sealed union with payload-carrying variants | Exhaustive switch handling + compile-time safety |

---

## Pattern: id-Based Lookup for Stable Object Identity

**Core Idea**: Bypass Equatable value equality by using stable id fields for object lookup in lists. id is assigned once at creation and never changes.

**Problem**: `indexOf()` uses `==` which compares all Equatable fields. When object is modified (e.g., an item field is updated), equality fails.

**Solution**: Use `indexWhere` with id comparison:
```dart
// Buggy - fails when object properties change
final itemIndex = items.indexOf(selectedItem);

// Fixed - stable identity regardless of property changes
final itemIndex = items.indexWhere((item) => item.id == selectedId);
```

**When to Use**:
- Object stored in list and retrieved by index
- Object may be replaced with modified copy
- Equatable fields change but identity should persist

**Trade-offs**: Requires objects to have a stable `id` field.

---

## Pattern: Child-to-Parent State Update via Callbacks

**Core Idea**: Child widgets update parent state by calling callback functions passed as props, enabling unidirectional data flow.

**Flow**:
```
User edits a field in the child
  ↓
Child (Section): Updates local state + calls callback
  ↓
Parent (Screen): Forwards to Cubit
  ↓
Cubit.updateX(): Persists to state
  ↓
emit(newState) → Widget rebuilds with new data
```

**Implementation**:
```dart
// Parent passes callback to child
Section(
  items: state.items,
  onItemUpdated: (index, item) {
    cubit.updateItem(itemIndex, index, item);
  },
)

// Child calls callback on change
void _updateName(int index, String name) {
  final updated = [...items];
  updated[index] = items[index].copyWith(name: name);
  setState(() => items = updated);
  widget.onItemUpdated?.call(index, updated[index]);
}
```

**Benefits**: Local UI updates immediately, state persists across navigation.

---

## Pattern: Cubit + Sealed State Classes

**Core Idea**: Sealed classes enable exhaustive state handling with flutter_bloc Cubit. Best suited for states that are true unions with payload-carrying variants.

```dart
// State hierarchy (Style B — exception; default is plain + Status enum)
sealed class MyFeatureState extends Equatable {
  const MyFeatureState();
  @override List<Object?> get props => [];
}

final class MyFeatureInitial extends MyFeatureState {
  const MyFeatureInitial();
}
final class MyFeatureLoading extends MyFeatureState {
  const MyFeatureLoading();
}
final class MyFeatureSuccess extends MyFeatureState {
  final List<MyEntity> items;
  const MyFeatureSuccess(this.items);
  @override List<Object?> get props => [items];
}
final class MyFeatureError extends MyFeatureState {
  final String message;
  const MyFeatureError(this.message);
  @override List<Object?> get props => [message];
}

// Cubit
class MyFeatureCubit extends Cubit<MyFeatureState> {
  final IMyFeatureRepository _repo;
  MyFeatureCubit({required IMyFeatureRepository repo})
      : _repo = repo,
        super(const MyFeatureInitial());
}
```

**Benefits**:
- Exhaustive switch handling (compile-time safety)
- Clear state transitions
- Pattern matching
- Each variant carries its own payload type

**When to use**:
- State has multiple distinct payloads (each variant = different shape)
- Builder/listener exhaustively `switch`es on variant
- Codegen overhead is acceptable (using `@freezed`)

**When NOT to use**:
- State is flat (single class + `enum Status` + nullable payload) — use the default plain pattern (Style A in `state-representation-per-layer.md`)

---

## Related Files

- State representation decision tree (default vs exception): `state-representation-per-layer.md`
- Cubit partial state updates: `../guides/flutter-bloc-patterns.md`
- Provider DI for cubits: `../guides/flutter-di.md`
- Dart language standards: `../../core/standards/dart.md`
