<!-- Context: project-intelligence/lookup/cubits | Priority: high | Version: 1.1 | Updated: 2026-07-02 -->

# Cubits Catalog

**Core Concept**: ~15 Cubits. Some are global (DI-registered in `dependencies.dart`), most are page-scoped (created in router via `BlocProvider`).

---

## Catalog

| Cubit                  | File (in `ui/{feature}/cubit/`)        | Scope  | State File        | Notes                          |
| ---------------------- | ------------------------------------- | ------ | ----------------- | ------------------------------ |
| `AuthCubit`              | `auth/cubit/auth_cubit.dart`            | Global | `auth_state.dart`  | Wraps IAuthRepository (sign-in/up/out) |
| `HomeCubit`              | `home/cubit/home_cubit.dart`            | Page   | `home_state.dart`  | Loads blocks + meetings via `GetHomeDataUseCase` |
| `ProfileCubit`           | `profile/cubit/profile_cubit.dart`      | Global* | `profile_state.dart` | Global in DI, but loaded on demand by route |
| `BlockDetailsCubit`      | `carnivalBlock/blockDetails/cubit/`     | Page   | `block_details_state.dart` | `blockId` from path |
| `EditBlockCubit`         | `carnivalBlock/editBlock/cubit/`        | Page   | `edit_block_state.dart` | `carnivalBlockId` from path |
| `AddMemberCubit`         | `carnivalBlock/addMember/cubit/`        | Page   | `add_member_state.dart` | `blockId` from path |
| `CreateMeetingCubit`     | `meetings/createMeeting/cubit/`         | Page   | `create_meeting_state.dart` | `carnivalBlockId` from path |
| `EditMeetingCubit`       | `meetings/editMeeting/cubit/`           | Page   | `edit_meeting_state.dart` | `meetingId` from path |
| `MeetingDetailsCubit`    | `meetings/meetingDetails/cubit/`        | Page   | `meeting_details_state.dart` | `meetingId` from path |
| `UserMeetingsCubit`      | `meetings/userMeetings/cubit/`          | Page   | `user_meetings_state.dart` | Loads via `GetUserMeetingsUseCase` |
| `MembersCubit`           | `members/cubit/`                        | Page   | `members_state.dart` | `..loadMembers()` |
| `CreateBlockCubit`       | `carnivalBlock/createBlock/cubit/`      | Page   | `create_block_state.dart` | Uses `ICarnivalBlocksRepository` + `ICarnivalBlockMembersRepository` + `GetCurrentUserData`; emits Loading/Success/Error |
| `JoinBlockCubit`         | `carnivalBlock/joinBlock/cubit/`        | Page   | `join_block_state.dart` | Uses `ICarnivalBlocksRepository` + `ICarnivalBlockMembersRepository` + `GetCurrentUserData`; emits Loading/Success/Error |
| `MeetingPresencesCubit`  | `meeting_presences/cubit/`              | Page   | `meeting_presences_state.dart` (part-file, freezed) | TODO scaffold — see `lib/routing/router.dart` line 270 (planned `IMeetingPresencesRepository`) |
| `SettingsCubit`          | `settings/cubit/`                       | Page   | `settings_state.dart` (part-file) | Minimal `SettingsState` (abstract + `SettingsInitial`); no dependencies yet |

---

## Scope Decision

| Scope   | When                                                |
| ------- | --------------------------------------------------- |
| Global   | Long-lived (auth), shared across screens, needed before router |
| Page     | Per-screen state, depends on path params, auto-dispose on pop |

---

## State Pattern (Canonical)

```dart
enum MyStatus { initial, loading, success, failure }

class MyState extends Equatable {
  const MyState({
    this.status = MyStatus.initial,
    this.data,
    this.errorMessage,
  });
  final MyStatus status;
  final MyEntity? data;
  final String? errorMessage;
  MyState copyWith({...}) => ...;
  @override
  List<Object?> get props => [status, data, errorMessage];
}
```

See `concepts/bloc-state-pattern.md` for the decision tree.

---

## Canonical Cubit

```dart
class MyCubit extends Cubit<MyState> {
  MyCubit({required MyUseCase useCase})
      : _useCase = useCase,
        super(const MyState());

  Future<void> load() async {
    emit(state.copyWith(status: MyStatus.loading));
    final result = await _useCase();
    if (result.isError()) {
      emit(state.copyWith(
        status: MyStatus.failure,
        errorMessage: result.exceptionOrNull().toString()));
      return;
    }
    emit(state.copyWith(
      status: MyStatus.success,
      data: result.getOrNull()));
  }
}
```

---

## Global Registration (DI in `dependencies.dart`)

```dart
Provider<AuthCubit>(
  create: (c) => AuthCubit(authRepository: c.read()),
),
Provider<ProfileCubit>(
  create: (c) => ProfileCubit(authRepository: c.read(), membersRepository: c.read()),
),
```

---

## Page-Scoped Registration (DI in `router.dart`)

```dart
BlocProvider(
  create: (context) =>
      HomeCubit(getHomeDataUseCase: context.read())..loadHomeData(),
  child: const HomeScreen(),
);
```

---

## Adding a New Cubit

1. Create `lib/ui/{feature}/cubit/{name}_state.dart` (Equatable + enum Status + copyWith)
2. Create `lib/ui/{feature}/cubit/{name}_cubit.dart` (extend Cubit)
3. Either:
   - Register globally in `dependencies.dart`, OR
   - Create page-scoped in `router.dart`
4. Wire screen via `BlocBuilder<NewCubit, NewState>` in `widgets/{name}_screen.dart`
5. Update this catalog

See: `lookup/ui-organization.md` — for folder-tree conventions when nesting cubits under a parent feature (e.g., `carnivalBlock/{sub_action}/cubit/`).

---

## Reference

- `concepts/bloc-state-pattern.md` — state decisions
- `examples/state-pattern.md` — canonical `HomeState` + `HomeCubit`
- `examples/widget-pattern.md` — `BlocBuilder` usage
- `lookup/use-cases.md` — what cubits consume
- `lookup/routes.md` — where cubits are scoped
