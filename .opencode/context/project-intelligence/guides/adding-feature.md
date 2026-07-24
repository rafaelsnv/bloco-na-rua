<!-- Context: project-intelligence/guides/adding-feature | Priority: high | Version: 1.2 | Updated: 2026-07-13 -->

# Guide — Adding a New Feature (5 Layers)

**Core Concept**: Every new feature = edits in 5 places: entity, repo + api, (optional) usecase, cubit + state, screen + route. Use this checklist so nothing is missed.

---

## Checklist

```
[ ] 1. Entity (lib/domain/entities/{feature}/{name}_entity.dart)
[ ] 2. ApiClient interface + impl (lib/data/services/api/{feature}/)
[ ] 3. Repository interface + impl (lib/data/repositories/{feature}/)
[ ] 4. UseCase (optional — lib/domain/use_cases/{feature}/)
[ ] 5. Cubit + State (lib/ui/{feature}/cubit/)
[ ] 6. Screen widget (lib/ui/{feature}/widgets/)
[ ] 7. Route + DI (router.dart + dependencies.dart)
[ ] 8. Update lookup/{entities,use-cases,routes,cubits}.md
[ ] 9. Run: dart run build_runner build --delete-conflicting-outputs
```

---

## Minimal Snippet per Layer

### Entity (freezed)

```dart
@freezed
sealed class SettingsEntity extends EntityBase
    with _$SettingsEntity {
  final bool notificationsEnabled;
  final String preferredLocale;
  SettingsEntity._({required this.notificationsEnabled, 
    required this.preferredLocale, required super.id}) : super();
  factory SettingsEntity({...}) = _SettingsEntity;
  factory SettingsEntity.fromJson(Map<String, dynamic> json) =>
      _$SettingsEntityFromJson(json);
}
```

### ApiClient + Repo (interfaces, AsyncResult returns)

```dart
abstract interface class ISettingsRepository {
  AsyncResult<SettingsEntity> getCurrent();
}

class SettingsRepository implements ISettingsRepository {
  SettingsRepository({required ISettingsApiClient api}) : _api = api;
  @override
  AsyncResult<SettingsEntity> getCurrent() async {
    try { return Success(await _api.getCurrent()); }
    on DioException catch (e) { return Failure(ApiError.fromDioException(e)); }
  }
}
```

### UseCase (optional, for orchestration later)

```dart
class GetSettingsUseCase {
  GetSettingsUseCase({required ISettingsRepository repo}) : _repo = repo;
  AsyncResult<SettingsEntity> call() => _repo.getCurrent();
}
```

### Cubit + State

```dart
enum SettingsStatus { initial, loading, success, failure }
class SettingsState extends Equatable {
  const SettingsState({this.status = SettingsStatus.initial,
    this.settings, this.errorMessage});
  // ... fields + copyWith + props
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required GetSettingsUseCase useCase})
      : _useCase = useCase, super(const SettingsState());
  Future<void> load() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    final r = await _useCase();
    if (r.isError()) {
      emit(state.copyWith(status: SettingsStatus.failure,
        errorMessage: r.exceptionOrNull().toString()));
      return;
    }
    emit(state.copyWith(status: SettingsStatus.success,
      settings: r.getOrNull()));
  }
}
```

### Screen + Route

```dart
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) => /* switch on status */,
      ),
    );
  }
}
```

```dart
// In router.dart
GoRoute(
  path: Routes.settings,
  pageBuilder: (context, state) => _buildPageWithSlideTransition(
    context: context, state: state,
    child: BlocProvider(
      create: (context) => 
          context.read<SettingsCubit>()..load(),
      child: const SettingsScreen(),
    ),
  ),
),
```

---

## Common Mistakes to Avoid

- ❌ Skip UseCase when it's actually needed (e.g., write + cache invalidation)
- ❌ Register page-scoped cubit in `dependencies.dart` (use `router.dart` instead)
- ❌ Forget `dart run build_runner build` after entity change
- ❌ Forget to add the route constant in `lib/routing/routes.dart`
- ❌ Skip the lookup table updates (stale docs = broken navigation)
- ❌ N+1 queries: use `Future.wait([fetch1(), fetch2(), ...])` for parallel fetches — never sequential awaits in `initState` or `load()`

---

## Reference (full templates)

- `concepts/freezed-entity.md` — full entity template + gotchas
- `examples/module-pattern.md` — Provider DI template
- `examples/state-pattern.md` — canonical HomeState + HomeCubit
- `examples/widget-pattern.md` — screen + BlocBuilder pattern
- `examples/home-feature-flow.md` — end-to-end trace
- `guides/error-to-user-message.md` — error propagation
- `lookup/{entities,use-cases,routes,cubits}.md` — update these!
