<!-- Context: project-intelligence/examples/resumable-cubit-pattern | Priority: high | Version: 1.0 | Updated: 2026-11-17 -->

# Resumable Cubit Pattern

**Core Concept**: `ResumableCubit<S>` extends `Cubit` with `WidgetsBindingObserver` to auto-refresh data when the app resumes from background. Extend it instead of plain `Cubit` for screens whose data can go stale.

---

## The Contract

Defined in `lib/ui/core/cubit/resumable_cubit_mixin.dart`:

```dart
abstract class ResumableCubit<S> extends Cubit<S>
    with WidgetsBindingObserver {
  ResumableCubit(super.initialState) {
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> onResumed(); // implement your refresh logic

  @override
  Future<void> close() { // observer removed automatically
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
```

---

## Minimal Usage

```dart
class UserMeetingsCubit extends ResumableCubit<UserMeetingsState> {
  UserMeetingsCubit({required GetUserMeetingsUseCase useCase})
      : _useCase = useCase, super(const UserMeetingsState());

  final GetUserMeetingsUseCase _useCase;

  @override
  Future<void> onResumed() => loadMeetings(); // auto-called on resume

  Future<void> loadMeetings() async {
    emit(state.copyWith(status: UserMeetingsStatus.loading));
    // ... fold result and emit success/failure
  }
}
```

---

## Key Points

1. Extend `ResumableCubit<S>` instead of `Cubit<S>` — everything else is identical
2. Override `onResumed()` and point it at your load/refresh method
3. Base class handles: observer registration, resume detection, re-entrancy guard (`_isReloading`), error logging, and observer cleanup in `close()`
4. Used by: home, blockList, userMeetings, and profile cubits
5. State shape stays the same: status enum + single Equatable class (`examples/state-pattern.md`)

---

## Reference

- Base class: `lib/ui/core/cubit/resumable_cubit_mixin.dart`
- Example consumer: `lib/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart`
