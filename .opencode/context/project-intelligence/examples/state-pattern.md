<!-- Context: project-intelligence/examples/state-pattern | Priority: high | Version: 2.0 | Updated: 2026-11-17 -->

# State Pattern Example

**Core Concept**: State management uses Cubit + a single Equatable state class with a status enum and `copyWith`. This project does NOT use sealed state-class variants — one state class per feature.

---

## Status Enum + Single State Class

```dart
enum UserMeetingsStatus { initial, loading, success, failure }

class UserMeetingsState extends Equatable {
  const UserMeetingsState({
    this.status = UserMeetingsStatus.initial,
    this.meetings = const <MeetingEntity>[],
    this.errorMessage,
  });

  final UserMeetingsStatus status;
  final List<MeetingEntity> meetings;
  final String? errorMessage;

  UserMeetingsState copyWith({
    UserMeetingsStatus? status,
    List<MeetingEntity>? meetings,
    String? errorMessage,
  }) =>
      UserMeetingsState(
        status: status ?? this.status,
        meetings: meetings ?? this.meetings,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, meetings, errorMessage];
}
```

---

## Cubit Usage

```dart
class UserMeetingsCubit extends Cubit<UserMeetingsState> {
  UserMeetingsCubit({required GetUserMeetingsUseCase useCase})
      : _useCase = useCase, super(const UserMeetingsState());

  Future<void> loadMeetings() async {
    emit(state.copyWith(status: UserMeetingsStatus.loading));
    final result = await _useCase();
    result.fold(
      (meetings) => emit(state.copyWith(
        status: UserMeetingsStatus.success, meetings: meetings)),
      (failure) => emit(state.copyWith(
        status: UserMeetingsStatus.failure,
        errorMessage: failure.toString())),
    );
  }
}
```

---

## Key Points

1. One state class per feature: `XxxState extends Equatable` with `copyWith`
2. Lifecycle expressed via a status enum: `initial → loading → success/failure`
3. Error state carries an optional `errorMessage` string — no separate error class
4. Emit via `state.copyWith(...)`, never mutate in place
5. UI branches on `state.status` inside `BlocBuilder`

---

## Reference

- Model: `lib/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart`
- Wiring: `examples/module-pattern.md`
- Lifecycle refresh: `examples/resumable-cubit-pattern.md`
