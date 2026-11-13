<!-- Context: project-intelligence/technical | Priority: critical | Version: 1.1 | Updated: 2026-10-20 -->

# Technical Domain

**Purpose**: Tech stack, architecture patterns, and development conventions for Bloco na Rua Flutter app.
**Last Updated**: 2026-10-20

## Quick Reference
**Update Triggers**: Tech stack changes | New architectural patterns | API changes
**Audience**: Developers, AI agents

## Primary Stack
| Layer | Technology | Version | Rationale |
|-------|-----------|---------|-----------|
| Framework | Flutter | 3.8.1 | Cross-platform mobile |
| Language | Dart | ^3.8.1 | Null-safe, structured |
| State Management | flutter_bloc + Cubit | 9.1.1 | Predictable state, testable |
| HTTP Client | Dio | 5.9.0 | Interceptors, timeouts |
| Auth | Supabase + GoTrue | 2.10.0 / 2.14.0 | Backend-as-a-service auth |
| Routing | GoRouter | 18.0.2 | Declarative, deep linking |
| Dependency Injection | Provider | 6.1.5+1 | Simple, effective |
| Code Generation | Freezed, JSON Serializable | 4.0.1 / 6.7.1 | Immutable data classes |
| API Contract | Swagger | 4.1.1 | Auto-generated models |
| Result Type | result_dart | 2.1.1 | Success/Failure monad |
| Testing | bloc_test, mocktail | 10.0.0 / 1.0.4 | BDD-style bloc tests |

## Directory Structure
```
lib/
├── api/                   # Swagger-generated models
├── config/                # DI (dependencies.dart)
├── core/                  # Error handling, base classes, tokens
├── data/
│   ├── repositories/     # Repository implementations + interfaces
│   └── services/api/     # API clients per entity (base, meetings, members, etc.)
├── domain/
│   ├── entities/         # Freezed sealed classes
│   └── use_cases/        # Business logic
├── l10n/                 # ARB localizations (pt_BR, en)
├── routing/               # GoRouter setup
└── ui/
    ├── core/              # Shared widgets, theme, tokens
    └── [feature]/         # Screens + cubits (home, meetings, profile, etc.)
```

## Code Patterns

### Entity (Freezed Sealed Class)
```dart
@freezed
sealed class MeetingsEntity extends EntityBase with _$MeetingsEntity {
  MeetingsEntity._() : super(id: 0);
  factory MeetingsEntity({
    required int id,
    String? name,
    String? description,
    DateTime? meetingDateTime,
    int? carnivalBlockId,
  }) = _MeetingsEntity;
  factory MeetingsEntity.fromJson(Map<String, dynamic> json) =>
      _$MeetingsEntityFromJson(json);
}
```

### Repository Interface (thin, delegates to API client)
```dart
abstract interface class IMeetingsRepository {
  AsyncResult<List<MeetingsEntity>> getAllAsync();
  AsyncResult<MeetingsEntity> getByIdAsync(int id);
  AsyncResult<MeetingsEntity> createAsync(Map<String, dynamic> data);
  AsyncResult<MeetingsEntity> update(int id, Map<String, dynamic> data);
  AsyncResult delete(int id);
}
```

### API Client (Dio-based, returns Result)
```dart
class MeetingsApiClient implements IMeetingsApiClient {
  MeetingsApiClient(this.baseApiClient) {
    _basePath = '${baseApiClient.basePath}Meetings';
  }
  final IBaseApiClient baseApiClient;
  late final String _basePath;

  @override
  AsyncResult<MeetingsEntity> getByIdAsync(int id) async {
    try {
      final response = await baseApiClient.client.get('$_basePath/$id');
      if (response.statusCode != 200) return Failure(baseApiClient.formatError(response));
      return Success(MeetingsEntity.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(ApiError.fromDioException(e));
    }
  }
}
```

### Use Case (orchestrates repos, returns Result)
```dart
class GetUserMeetingsUseCase {
  GetUserMeetingsUseCase({required GetCurrentUserData getCurrentUserData, required IMembersRepository membersRepo})
      : _membersRepo = membersRepo, _getCurrentUserData = getCurrentUserData;
  final GetCurrentUserData _getCurrentUserData;
  final IMembersRepository _membersRepo;

  AsyncResult<List<MeetingsEntity>> call() async {
    try {
      final userDataResult = await _getCurrentUserData();
      if (userDataResult.isError()) return Failure(userDataResult.exceptionOrNull()!);
      // ... return Success or Failure
    } catch (e) { return Failure(Exception('Unexpected error: $e')); }
  }
}
```

### Cubit State (Equatable, status enum)
```dart
enum UserMeetingsStatus { initial, loading, success, failure }
class UserMeetingsState extends Equatable {
  const UserMeetingsState({this.status = UserMeetingsStatus.initial, this.meetings = const [], this.errorMessage});
  final UserMeetingsStatus status;
  final List<MeetingsEntity> meetings;
  final String? errorMessage;
  UserMeetingsState copyWith({UserMeetingsStatus? status, List<MeetingsEntity>? meetings, String? errorMessage}) =>
      UserMeetingsState(status: status ?? this.status, meetings: meetings ?? this.meetings, errorMessage: errorMessage ?? this.errorMessage);
  @override List<Object?> get props => [status, meetings, errorMessage];
}
```

### Cubit (extends ResumableCubitMixin for auto-refresh)
```dart
class UserMeetingsCubit extends ResumableCubit<UserMeetingsState> {
  UserMeetingsCubit({required GetUserMeetingsUseCase getUserMeetingsUseCase})
      : _getUserMeetingsUseCase = getUserMeetingsUseCase, super(const UserMeetingsState());
  final GetUserMeetingsUseCase _getUserMeetingsUseCase;
  final _log = Logger('UserMeetingsCubit');
  @override Future<void> onResumed() => loadMeetings();

  Future<void> loadMeetings() async {
    emit(state.copyWith(status: UserMeetingsStatus.loading));
    try {
      final result = await _getUserMeetingsUseCase();
      if (result.isError()) { emit(state.copyWith(status: UserMeetingsStatus.failure, errorMessage: extractUserMessage(result.exceptionOrNull()))); return; }
      emit(state.copyWith(status: UserMeetingsStatus.success, meetings: result.getOrNull() ?? []));
    } catch (e) { emit(state.copyWith(status: UserMeetingsStatus.failure)); }
  }
}
```

## Naming Conventions
| Type | Convention | Example |
|------|-----------|---------|
| Files | snake_case | `carnival_blocks_entity.dart` |
| Entities | PascalCase + Entity suffix | `CarnivalBlocksEntity` |
| Repository Interfaces | IPascalCase | `IMeetingsRepository` |
| API Clients | PascalCase | `MeetingsApiClient` |
| Use Cases | PascalCase + UseCase suffix | `GetUserMeetingsUseCase` |
| States | PascalCase + State suffix | `UserMeetingsState` |
| Cubits | PascalCase + Cubit suffix | `UserMeetingsCubit` |
| Widgets | PascalCase + Screen/Widget suffix | `UserMeetingsScreen` |
| Directories | snake_case | `user_meetings/` |

## Error Handling
```dart
// ApiError types: network, timeout, server, auth, validation, notFound, unknown
// From DioException: ApiError.fromDioException(e) → ApiError.type + userMessage
// From Response: ApiError.fromResponse(response) → statusCode-based mapping
// User-facing: error.toUserMessage(context) → localized or fallback
```

## Design System Tokens
```dart
// Theme: "Fireworks on Velvet"
// Primary (Violet): primary #7C3AED, light #A78BFA, dark #5B21B6
// Secondary (Magenta): #E11D74, container light #FDF2F8
// Accent/CTA (Gold): #D97706
// Tertiary (Cyan): #0E7490
// Semantic: success #16A34A, warning #F59E0B, error #DC2626, info #0EA5E9
// Surface: stone-based with violet tonal ladder
class AppColors {
  static const Color primary = Color(0xFF7C3AED);
  static const Color secondary = Color(0xFFE11D74);
  static const Color accent = Color(0xFFD97706);
  static const Color tertiary = Color(0xFF0E7490);
  // ... full palette in lib/ui/core/tokens/app_colors.dart
}
```

## 📂 Codebase References
| Component | Path |
| --------- | ---- |
| Entity | `lib/domain/entities/members/members_entity.dart` |
| API Client | `lib/data/services/api/base/base_api_client.dart` |
| Repository | `lib/data/repositories/meetings/meetings_repository.dart` |
| Use Case | `lib/domain/use_cases/meetings/get_user_meetings_use_case.dart` |
| Cubit | `lib/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart` |
| State | `lib/ui/meetings/userMeetings/cubit/user_meetings_state.dart` |
| DI | `lib/config/dependencies.dart` |
| Routing | `lib/routing/router.dart` |
| Theme | `lib/ui/core/tokens/app_colors.dart` |
