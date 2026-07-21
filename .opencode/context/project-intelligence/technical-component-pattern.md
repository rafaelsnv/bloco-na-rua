<!-- Context: project-intelligence/technical-component-pattern | Priority: high | Version: 3.0 | Updated: 2026-07-02 -->

# Component Pattern — Per-Layer Contract

**Core Concept**: Each layer has a strict contract. Outer layers depend on inner ones, never the reverse. Cubits consume UseCases; UseCases consume Repositories; Repositories own ApiClients.

---

## The 5 Component Layers

```
┌───────────────────────────────────────────────────┐
│  1. Screen Widget   ← consumes Cubit              │
├───────────────────────────────────────────────────┤
│  2. Cubit (UI)      ← consumes UseCases           │
├───────────────────────────────────────────────────┤
│  3. UseCase (Domain) ← consumes Repositories      │
├───────────────────────────────────────────────────┤
│  4. Repository (Data) ← owns ApiClients           │
├───────────────────────────────────────────────────┤
│  5. ApiClient (Data)  ← owns Dio transport        │
└───────────────────────────────────────────────────┘
```

**Direction of dependency**: ALWAYS downward. Never upward, never sideways.

---

## 1. Screen Widget

- **Knows about**: Cubit (only)
- **Doesn't know about**: Use cases, repos, api
- **Contract**: `BlocBuilder<MyCubit, MyState>` or `BlocConsumer`
- **Example**: `lib/ui/home/widgets/home_screen.dart`

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => /* switch on status */,
      ),
    );
  }
}
```

---

## 2. Cubit

- **Knows about**: Use cases (via constructor)
- **Doesn't know about**: Repositories, api, Dio
- **Contract**: `extends Cubit<MyState>` with initial state in `super()`
- **Returns**: emits `MyState`, NEVER throws to widget tree
- **Example**: `lib/ui/home/cubit/home_cubit.dart`

```dart
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required GetHomeDataUseCase getHomeDataUseCase})
      : _getHomeDataUseCase = getHomeDataUseCase,
        super(const HomeState());

  final GetHomeDataUseCase _getHomeDataUseCase;
  final _log = Logger('HomeCubit');

  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));
    // ... orchestrate use case calls ...
  }
}
```

---

## 3. UseCase (Domain)

- **Knows about**: Repositories (constructor-injected)
- **Doesn't know about**: Cubits, widgets, Dio
- **Contract**: plain class, pure Dart (no Flutter import)
- **Returns**: `AsyncResult<T>` from `result_dart`
- **Example**: `lib/domain/use_cases/home/get_home_data_use_case.dart`

```dart
class GetHomeDataUseCase {
  GetHomeDataUseCase({
    required GetCurrentUserData getCurrentUserData,
    required IMembersRepository membersRepo,
  }) : _membersRepo = membersRepo,
       _getCurrentUserData = getCurrentUserData;

  final GetCurrentUserData _getCurrentUserData;
  final IMembersRepository _membersRepo;
  final _log = Logger('GetHomeDataUseCase');

  AsyncResult<List<CarnivalBlocksEntity>> getCarnivalBlocks() async {
    try {
      final userDataResult = await _getCurrentUserData();
      if (userDataResult.isError()) {
        return Failure(userDataResult.exceptionOrNull()!);
      }
      final userId = userDataResult.getOrNull()!.id;
      return await _membersRepo.getBlocksByMemberId(userId);
    } catch (e) {
      _log.severe('Unexpected error in getCarnivalBlocks', e);
      return Failure(Exception(e.toString()));
    }
  }
}
```

---

## 4. Repository (Data)

- **Knows about**: ApiClients (constructor-injected)
- **Doesn't know about**: Use cases, Cubits
- **Contract**: `implements I{Feature}Repository` (interface + impl split)
- **Returns**: `AsyncResult<T>` — translates exceptions to `ApiError`
- **Example**: `lib/data/repositories/meetings/meetings_repository.dart`

```dart
class MeetingsRepository implements IMeetingsRepository {
  MeetingsRepository({required IMeetingsApiClient meetingsApiClient})
      : _api = meetingsApiClient;
  final IMeetingsApiClient _api;
  final _log = Logger('MeetingsRepository');

  @override
  AsyncResult<List<MeetingsEntity>> getByBlock(int blockId) async {
    try {
      final list = await _api.getByBlock(blockId);
      return Success(list);
    } on DioException catch (e) {
      _log.warning('getByBlock($blockId) failed', e);
      return Failure(ApiError.fromDioException(e));
    }
  }
}
```

---

## 5. ApiClient (Data)

- **Knows about**: `BaseApiClient` (injected)
- **Doesn't know about**: Repositories, UseCases
- **Contract**: `implements I{Feature}ApiClient` (interface + impl split)
- **Returns**: parsed entity (`fromJson`) or throws `DioException`
- **Example**: `lib/data/services/api/meetings/meetings_api_client.dart`

```dart
class MeetingsApiClient implements IMeetingsApiClient {
  MeetingsApiClient(this._base);
  final IBaseApiClient _base;

  @override
  Future<List<MeetingsEntity>> getByBlock(int blockId) async {
    final response =
        await _base.get<dynamic>('/meetings/block/$blockId');
    final data = response.data as List;
    return data
      .map((j) => MeetingsEntity.fromJson(j as Map<String, dynamic>))
      .toList();
  }
}
```

---

## Anti-Patterns

| Violation                                              | Why it's wrong                              |
| ------------------------------------------------------ | ------------------------------------------- |
| Cubit imports `Dio`                                    | Bypasses UseCase + Error pipeline           |
| UseCase imports `BuildContext`                         | UseCase must be pure Dart                   |
| Repository returns `T` directly (no Result)            | Breaks error contract                        |
| ApiClient catches exceptions                            | Repos own that translation                   |
| Widget calls `_repo.method()` directly                  | Bypasses UseCase orchestration              |
| Multiple cubits per page                               | Split logic to multiple states if needed    |

---

## Reference

- `concepts/architecture.md` — layer responsibilities
- `concepts/result-handling.md` — `AsyncResult<T>` details
- `concepts/dio-pipeline.md` — where exceptions enter
- `examples/state-pattern.md` — cubit
- `lookup/entities.md`, `lookup/use-cases.md`, `lookup/cubits.md`
