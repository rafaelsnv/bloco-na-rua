<!-- Context: project-intelligence/examples/home-feature-flow | Priority: critical | Version: 1.0 | Updated: 2026-07-02 -->

# Home Feature — End-to-End Flow

**Core Concept**: Trace a "user opens the app and sees dashboard" from `main.dart` boot to `HomeCubit` emitting `success` with blocks + meetings. Pure read-only feature, ideal for understanding the layered architecture.

---

## Call Chain (Forward)

```
main.dart
  └─ MainApp
      └─ AuthCubit (top-level, validates session via Supabase)
          └─ GoRouter redirects to /home if session valid
              └─ HomeScreen
                  └─ BlocProvider<HomeCubit>
                      └─ HomeCubit.loadHomeData()
                          └─ GetHomeDataUseCase.getCarnivalBlocks()
                              └─ GetCurrentUserData()
                                  └─ IAuthRepository.validateSession()
                                      └─ (Supabase client cached)
                          └─ IMembersRepository.getBlocksByMemberId(uid)
                              └─ ICarnivalBlockMembersApiClient
                                  └─ BaseApiClient.get<T>(...)
                                      └─ Dio (with interceptors)
                                          └─ REST API
```

---

## File Touchlist

| Step | Layer      | File                                                   |
| ---- | ---------- | ------------------------------------------------------ |
| 1    | Bootstrap  | `lib/main.dart`                                        |
| 2    | Auth gate  | `lib/main_app.dart` (AuthCubit)                        |
| 3    | Route      | `lib/routing/router.dart` (home pageBuilder)            |
| 4    | Screen     | `lib/ui/home/widgets/home_screen.dart`                 |
| 5    | Cubit      | `lib/ui/home/cubit/home_cubit.dart`                    |
| 6    | UseCase    | `lib/domain/use_cases/home/get_home_data_use_case.dart` |
| 7    | UseCase (sub) | `lib/domain/use_cases/auth/get_current_user_data.dart` |
| 8    | Repo       | `lib/data/repositories/members/members_repository.dart` |
| 9    | ApiClient  | `lib/data/services/api/carnivalBlockMembers/...`       |
| 10   | BaseClient | `lib/data/services/api/base/base_api_client.dart`      |
| 11   | Dio        | (injected via BaseApiClient factory)                   |

---

## Step-by-Step

### Step 1 — `main.dart` boot

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  Logger.root.level = Level.WARNING;
  runApp(MultiProvider(providers: providers, child: const MainApp()));
}
```

### Step 2 — `MainApp` builds MaterialApp.router

```dart
return BlocProvider(
  create: (context) => AuthCubit(authRepository: context.read()),
  child: MaterialApp.router(
    routerConfig: router(context.read()),
    ...
  ),
);
```

### Step 3 — GoRouter redirects to `/home`

`router.dart`:
```dart
final _router = router(authRepository);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final sessionValid = await context.read<IAuthRepository>().validateSession();
  final location = state.matchedLocation;
  if (!sessionValid) return Routes.login;
  if ([Routes.login, Routes.register].contains(location)) return Routes.home;
  return null;
}
```

### Step 4 — Home route builds the screen

```dart
GoRoute(
  path: Routes.home,
  pageBuilder: (context, state) => _buildPageWithSlideTransition(
    context: context,
    state: state,
    child: BlocProvider(
      create: (context) =>
          HomeCubit(getHomeDataUseCase: context.read())..loadHomeData(),
      child: const HomeScreen(),
    ),
  ),
),
```

### Step 5 — `HomeCubit` orchestrates

```dart
Future<void> loadHomeData() async {
  emit(state.copyWith(status: HomeStatus.loading));
  try {
    final results = await Future.wait([
      _getHomeDataUseCase.getCarnivalBlocks(),
      _getHomeDataUseCase.getMeetings(),
    ]);
    if (results.any((r) => r.isError())) {
      final err = results.firstWhere((r) => r.isError()).exceptionOrNull();
      emit(state.copyWith(status: HomeStatus.failure,
        errorMessage: _extractUserMessage(err)));
      return;
    }
    emit(state.copyWith(
      status: HomeStatus.success,
      blocks: results[0].getOrNull() ?? [],
      meetings: results[1].getOrNull() ?? [],
    ));
  } catch (e) {
    emit(state.copyWith(status: HomeStatus.failure,
      errorMessage: _extractUserMessage(e)));
  }
}
```

### Step 6 — `GetHomeDataUseCase.getCarnivalBlocks()`

```dart
AsyncResult<List<CarnivalBlocksEntity>> getCarnivalBlocks() async {
  try {
    final userDataResult = await _getUserData();
    if (userDataResult.isError()) return Failure(userDataResult.exceptionOrNull()!);
    final userId = userDataResult.getOrNull()!.id;

    final blocksResult = await _membersRepo.getBlocksByMemberId(userId);
    if (blocksResult.isError()) return Failure(blocksResult.exceptionOrNull()!);
    final blocks = blocksResult.getOrNull();
    if (blocks == null || blocks.isEmpty) return Success([]);

    return Success(blocks);
  } catch (e) {
    _log.severe('Unexpected error during load', e);
    return Failure(Exception('Unexpected error: $e'));
  }
}
```

### Steps 7-11 — Same shape for sub-calls

Each layer consumes the previous layer's `AsyncResult<T>` and produces its own.

---

## Side Effects During This Flow

- **Logging**: `Logger('HomeCubit')` + `Logger('GetHomeDataUseCase')` + `Logger('PrettyDioLogger')` fire at each layer
- **Token check**: `IAuthRepository.validateSession()` reads JWT from `SharedPreferences` + pings Supabase
- **Error translation**: `ApiError.fromDioException` only fires IF a `DioException` is thrown (rare on the happy path)

---

## Reference

- `concepts/architecture.md` — layer diagram
- `concepts/result-handling.md` — `AsyncResult<T>`
- `examples/state-pattern.md` — `HomeState` + `HomeCubit`
- `lookup/entities.md`, `lookup/use-cases.md`, `lookup/routes.md`
