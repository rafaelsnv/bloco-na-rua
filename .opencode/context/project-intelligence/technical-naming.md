<!-- Context: project-intelligence/technical-naming | Priority: high | Version: 3.0 | Updated: 2026-07-02 -->

# Naming Conventions — BlocoNaRua

**Purpose**: Conventions for Flutter/Dart code in this repo. Adapted from official Dart + flutter_bloc guidance.

## File & Folder Naming

| Type | Convention | Example | Notes |
|------|------------|---------|-------|
| Dart files   | snake_case.dart      | `entity_repository.dart`             | |
| Folders      | camelCase (NOT snake_case) | `carnivalBlock/`, `meetingPresences/` | e.g. `lib/ui/carnivalBlock/...` |
| Test files   | `*_test.dart`        | `home_cubit_test.dart`               | |
| Generated    | `*.freezed.dart`, `*.g.dart` | `carnival_blocks_entity.freezed.dart` | Generated; don't edit |

## Class & Type Naming

| Type | Convention | Example |
|------|------------|---------|
| Entities           | PascalCase + Entity suffix | `CarnivalBlocksEntity` |
| Repository interfaces | PascalCase + `I` prefix | `IMeetingsRepository` |
| Repository impls   | PascalCase (no suffix) | `MeetingsRepository` |
| API client interfaces | PascalCase + `I` prefix | `IMeetingsApiClient` |
| API client impls   | PascalCase | `MeetingsApiClient` |
| Base interface     | PascalCase + `I` prefix | `IBaseApiClient` |
| State classes      | PascalCase + State suffix | `HomeState`, `MeetingDetailsState` |
| State enums        | PascalCase + Status suffix | `HomeStatus`, `MeetingDetailsStatus` |
| Cubit classes      | PascalCase + Cubit suffix | `HomeCubit`, `AuthCubit` |
| Use cases          | PascalCase + UseCase suffix | `GetHomeDataUseCase` |
| Screen widgets     | PascalCase + Screen suffix | `HomeScreen`, `LoginScreen` |
| Modal widgets      | PascalCase + Modal suffix | `JoinBlockModal` |
| Routes class       | PascalCase (single) | `class Routes { ... }` |
| Logger instances   | lowercase context name | `Logger('HomeCubit')` |

## Member Naming

| Type | Convention | Example |
|------|------------|---------|
| Public functions/methods | camelCase, verb | `loadHomeData`, `getBlocksByMemberId` |
| Predicates | `is/has/can` prefix | `isValid`, `hasPermission` |
| Variables | camelCase (descriptive) | `userCount` (NOT `uc`) |
| Constants | lowercase camelCase (NO `k` prefix) | `baseOptions`, `supabaseClient` |
| Private fields | `_camelCase` | `_api`, `_membersRepo` |
| Enums         | PascalCase name | `enum HomeStatus { ... }` |
| Enum values   | camelCase       | `HomeStatus.loading` (NOT `HomeStatus.LOADING`) |

## Quick Examples (CORRECT vs WRONG)

```dart
// ✅ CORRECT (project conventions)
class CarnivalBlocksEntity extends EntityBase { ... }
abstract interface class IMeetingsRepository { ... }
class MeetingsRepository implements IMeetingsRepository { ... }
class HomeCubit extends Cubit<HomeState> { ... }
enum HomeStatus { initial, loading, success, failure }
var baseOptions = BaseOptions(...);                    // no k prefix
final _membersRepo = ...;                             // private fields

// ❌ WRONG (rejected in this project)
class carnival_blocks_entity { }                       // snake_case file/class
class MeetingRepo { }                                  // missing Repository suffix
class MeetingsRepoService { }                          // made-up suffix
class HomeViewModel extends Cubit<HomeState> { }       // Wrong — use Cubit
class HomeState extends Equatable { ... }              // Wrong — use enum Status
const kBaseOptions = ...;                              // No k prefix in this project
enum HomeStatus { INITIAL, LOADING }                   // Use camelCase enum values
```

## Route Naming

| Type | Convention | Example |
|------|------------|---------|
| Route constants | camelCase | `Routes.login`, `Routes.userMeetings` |
| Route paths    | kebab-case (multi-word) or `/` | `/`, `/login`, `/carnival-block/:id`, `/meeting/:id` |
| Path params    | camelCase | `:id`, `:blockId` |

> Note: paths for ONE-word routes are simple (`/members`); multi-word uses kebab (`/meeting-presences`).

## Codebase Locations (CANONICAL)

| Item | Path |
|------|------|
| Entities | `lib/domain/entities/{feature}/` |
| Entity source | `lib/domain/entities/{feature}/{feature}_entity.dart` |
| Use cases | `lib/domain/use_cases/{feature}/` |
| Repositories | `lib/data/repositories/{feature}/` |
| Repository interface | `lib/data/repositories/{feature}/i{feature}_repository.dart` |
| Repository impl | `lib/data/repositories/{feature}/{feature}_repository.dart` |
| API clients | `lib/data/services/api/{feature}/` |
| Supabase auth client | `lib/data/services/auth/auth_api_client.dart` |
| Cross-cutting | `lib/core/` (ApiError, EntityBase, etc.) |
| DI container | `lib/config/dependencies.dart` (SINGLE file) |
| Cubits | `lib/ui/{feature}/cubit/` |
| State classes | `lib/ui/{feature}/cubit/{feature}_state.dart` |
| Cubits | `lib/ui/{feature}/cubit/{feature}_cubit.dart` |
| Screens | `lib/ui/{feature}/widgets/{feature}_screen.dart` |
| Shared UI | `lib/ui/core/{colors, theme, widgets}/` |
| Routes | `lib/routing/routes.dart` (constants) and `lib/routing/router.dart` (config) |

## Related

- `technical-domain.md` — entry point
- `technical-component-pattern.md` — layer contracts
- `concepts/architecture.md` — directory tree
