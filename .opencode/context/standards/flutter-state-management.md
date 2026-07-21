<!-- Context: standards/flutter-state-management | Priority: high | Version: 2.0 | Updated: 2026-07-13 -->

# Flutter State Management Patterns

> Universal Flutter state management patterns — applicable across any Flutter project.

## Quick Reference

| Pattern | When to Use | Key Benefit |
|---------|-------------|-------------|
| id-Based Lookup | Object in list may be replaced with modified copy | Stable identity regardless of property changes |
| Child-to-Parent Callbacks | Parent passes callback to child for state updates | Unidirectional data flow |
| Cubit + Sealed State | Cubit UI state is a sealed union with payload-carrying variants | Exhaustive switch handling + compile-time safety |
| BlocListener + listenWhen | Side effects (snackbars, navigation) on specific state transitions | Prevents duplicate triggers on repeated states |

---

## Pattern: id-Based Lookup for Stable Object Identity

**Core Idea**: Bypass Equatable value equality by using stable id fields for object lookup in lists. id is assigned once at creation and never changes.

**Problem**: `indexOf()` uses `==` which compares all Equatable fields. When object is modified (e.g., `chartDataPoints` updated), equality fails.

**Solution**: Use `indexWhere` with id comparison:
```dart
// ❌ Buggy - fails when object properties change
final testIndex = openTests.indexOf(selectedTest);

// ✅ Fixed - stable identity regardless of property changes
final testIndex = openTests.indexWhere((test) => test.id == selectedId);
```

**When to Use**:
- Object stored in list and retrieved by index
- Object may be replaced with modified copy
- Equatable fields change but identity should persist

**Trade-offs**: Requires objects to have stable `id` field.

---

## Pattern: Child-to-Parent State Update via Callbacks

**Core Idea**: Child widgets update parent state by calling callback functions passed as props, enabling unidirectional data flow.

**Flow**:
```
User edits event name
  ↓
Child (EventsSection): Updates local state + calls callback
  ↓
Parent (Screen): Forwards to Cubit
  ↓
Cubit.updateEvent(): Persists to state
  ↓
emit(newState) → _onStateChanged() → Widget rebuilds with new data
```

**Implementation**:
```dart
// Parent passes callback to child
EventsSection(
  events: test.events,
  onEventUpdated: (index, event) {
    cubit.updateEvent(testIndex, index, event);
  },
)

// Child calls callback on change
void _updateEventName(int index, String name) {
  final updated = [...events];
  updated[index] = events[index].copyWith(name: name);
  setState(() => events = updated);
  widget.onEventUpdated?.call(index, updated[index]);
}
```

**Benefits**: Local UI updates immediately, state persists across navigation.

---

## Pattern: Cubit + Sealed State Classes

**Core Idea**: Sealed classes enable exhaustive state handling with flutter_bloc Cubit.

**State hierarchy (reference structure)**:
```dart
sealed class EntityState extends Equatable {
  const EntityState();
  @override List<Object?> get props => [];
}

final class EntityInitial extends EntityState {}
final class EntityLoading extends EntityState {}
final class EntitySuccess extends EntityState {
  final List<Entity> entities;
  const EntitySuccess(this.entities);
}
final class EntityError extends EntityState {
  final String message;
  const EntityError(this.message);
}

// Cubit
class EntityCubit extends Cubit<EntityState> {
  final IXxxRepository _repo;
  EntityCubit({required IXxxRepository repo})
      : _repo = repo,
        super(EntityInitial());
}
```

**Benefits of sealed class approach**:
- Exhaustive switch handling (compile-time safety)
- Clear state transitions
- Equatable for efficient rebuilds

---

## Pattern: BlocListener + listenWhen for Side Effects

**Core Idea**: Use `BlocListener` with `listenWhen` to trigger side effects (snackbars, navigation) only on specific state transitions, avoiding duplicates when the same state is reached multiple times.

**Problem**: Without `listenWhen`, a `BlocListener` fires every time the bloc emits a state, even if it's the same state reached again (e.g., repeated markPresence calls showing duplicate snackbars).

**Solution**:
```dart
BlocListener<MeetingDetailsCubit, MeetingDetailsState>(
  listenWhen: (previous, current) =>
      previous.presenceStatus != current.presenceStatus &&
      current.presenceStatus == PresenceStatus.marked,
  listener: (context, state) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Presença confirmada!')),
    );
  },
)
```

**Rules**:
- `listenWhen` compares previous vs current state
- Only fire when transition is meaningful (not just any state change)
- Use for: snackbars, navigation, analytics — never for UI rebuilds

---

## Related Files

- `project-intelligence/concepts/bloc-state-pattern.md`
- `~/.config/opencode/context/development/concepts/flutter-state-management.md`
- `~/.config/opencode/context/core/standards/dart.md`
