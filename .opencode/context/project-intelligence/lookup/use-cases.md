<!-- Context: project-intelligence/lookup/use-cases | Priority: high | Version: 1.0 | Updated: 2026-07-02 -->

# Use Cases Catalog

**Core Concept**: 3 use cases currently. Most Cubits call repositories directly (a known gap — see `living-notes.md`).

---

## Current Use Cases

### `GetCurrentUserData`

- **File**: `lib/domain/use_cases/auth/get_current_user_data.dart`
- **Repos**: `IAuthRepository`, `IMembersRepository`
- **Returns**: `AsyncResult<MembersEntity>`
- **Used by**:
  - `AuthCubit` (session restore)
  - `GetHomeDataUseCase` (cascade)
  - `GetUserMeetingsUseCase` (cascade)

### `GetHomeDataUseCase`

- **File**: `lib/domain/use_cases/home/get_home_data_use_case.dart`
- **Methods**:
  - `getCarnivalBlocks()` → `AsyncResult<List<CarnivalBlocksEntity>>`
  - `getMeetings()` → `AsyncResult<List<MeetingsEntity>>`
- **Repos used (via cascade)**: `IMembersRepository.getBlocksByMemberId`, `getMeetingsByMemberId`
- **Used by**: `HomeCubit.loadHomeData` (parallel via `Future.wait`)

### `GetUserMeetingsUseCase`

- **File**: `lib/domain/use_cases/meetings/get_user_meetings_use_case.dart`
- **Repos**: (via `GetCurrentUserData` cascade + `IMembersRepository.getMeetingsByMemberId`)
- **Returns**: `AsyncResult<List<MeetingsEntity>>`
- **Used by**: `UserMeetingsCubit.loadMeetings`

---

## Gaps (Cubits Without UseCase)

The following Cubits call repositories DIRECTLY — recommended to extract a UseCase:

| Cubit                | Currently Calls                                         | Suggested UseCase               |
| -------------------- | ------------------------------------------------------- | ------------------------------- |
| `CreateMeetingCubit`   | `IMeetingsRepository` (write)                            | `CreateMeetingUseCase`            |
| `EditMeetingCubit`     | `IMeetingsRepository` (write)                            | `UpdateMeetingUseCase`            |
| `EditBlockCubit`       | `ICarnivalBlocksRepository` (write)                      | `UpdateBlockUseCase`              |
| `AddMemberCubit`       | `IMembersRepository` + `ICarnivalBlockMembersRepository` | `AddBlockMemberUseCase`           |
| `MembersCubit`         | `IMembersRepository` (read)                              | `ListMembersUseCase`              |
| `BlockDetailsCubit`    | `ICarnivalBlocksRepository` + `GetCurrentUserData`        | `GetBlockDetailsUseCase`          |
| `MeetingDetailsCubit`  | 4 repos (read)                                           | `GetMeetingDetailsUseCase`        |
| `ProfileCubit`         | `IAuthRepository` + `IMembersRepository`                 | `GetProfileUseCase`               |

**When to fix**: Next time any of these cubits needs extra orchestration (e.g., write + cache invalidation), extract the use case.

See `living-notes.md` for current effort status.

---

## UseCase Template

```dart
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class MyUseCase {
  MyUseCase({required MyRepository repo}) : _repo = repo;
  final MyRepository _repo;
  final _log = Logger('MyUseCase');

  AsyncResult<MyEntity> call() async {
    try {
      final result = await _repo.getSomething();
      return result;   // already AsyncResult
    } catch (e) {
      _log.severe('Unexpected error in call', e);
      return Failure(Exception(e.toString()));
    }
  }
}
```

---

## Reference

- `domain/use_cases/` — folder
- `concepts/result-handling.md` — `AsyncResult<T>`
- `business-tech-bridge.md` — conceptual mapping
