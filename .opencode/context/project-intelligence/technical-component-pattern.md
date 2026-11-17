<!-- Context: project-intelligence/technical-component | Priority: high | Version: 1.1 | Updated: 2026-11-17 -->

# Component Patterns

**Purpose**: State, cubit, screen, and router patterns.
**Audience**: AI agents implementing Flutter UI with BLoC

## State Pattern

Single Equatable state class + status enum (NOT sealed-class variants):

```dart
enum CreateEntityStatus { initial, loading, success, failure }

class CreateEntityState extends Equatable {
  const CreateEntityState({
    this.status = CreateEntityStatus.initial,
    this.entity,
    this.errorMessage,
  });
  final CreateEntityStatus status;
  final Entity? entity;
  final String? errorMessage;

  CreateEntityState copyWith({
    CreateEntityStatus? status,
    Entity? entity,
    String? errorMessage,
  }) => CreateEntityState(
    status: status ?? this.status,
    entity: entity ?? this.entity,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override List<Object?> get props => [status, entity, errorMessage];
}
```

Cubits emit via `state.copyWith(status: CreateEntityStatus.loading)`. UI branches on `state.status`.

## Cubit Pattern

```dart
class EditEntityCubit extends Cubit<CreateEntityState> {
  EditEntityCubit({
    required IEntityRepository repo,
    required String entityId,
  }) : _repo = repo, _entityId = entityId, super(CreateEntityInitial()) {
    loadEntity();
  }

  Future<void> loadEntity() async {
    emit(CreateEntityLoading());
    final result = await _repo.getByIdAsync(int.parse(_entityId));
    result.fold(
      (entity) => emit(EditEntityLoaded(id: entity.id, name: entity.name)),
      (failure) => emit(CreateEntityError(failure.toString())),
    );
  }
}
```

## Screen Pattern

```dart
class EditEntityScreen extends StatefulWidget {
  final String entityId;
  const EditEntityScreen({super.key, required this.entityId});
  @override State<EditEntityScreen> createState() => _EditEntityScreenState();
}

class _EditEntityScreenState extends State<EditEntityScreen> {
  final _nameController = TextEditingController();
  @override void dispose() { _nameController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => EditEntityCubit(
        repo: ctx.read<IEntityRepository>(),
        entityId: widget.entityId,
      ),
      child: BlocConsumer<EditEntityCubit, CreateEntityState>(
        listener: (ctx, state) {
          if (state is CreateEntitySuccess) ctx.go(Routes.home);
          else if (state is CreateEntityError) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (ctx, state) { /* ... */ },
      ),
    );
  }
}
```

## Router Pattern

`GoRouter` with async auth redirect calling `validateSession()`:

```dart
GoRouter router(AuthListenable authListenable) => GoRouter(
  initialLocation: Routes.login,
  redirect: _redirect,
  refreshListenable: authListenable, // AuthListenable (ChangeNotifier)
  observers: [Routes.routeObserver],
  routes: [ /* GoRoute entries; detail routes wrap screen in
             BlocProvider via pageBuilder + slide transition */ ],
);

Future<String?> _redirect(BuildContext ctx, GoRouterState state) async {
  final sessionValid = await ctx.read<IAuthRepository>().validateSession();
  if (!sessionValid) {
    if (state.matchedLocation == Routes.register) return null;
    return Routes.login;
  }
  if ([Routes.login, Routes.register].contains(state.matchedLocation)) {
    return Routes.home;
  }
  return null;
}
```

## ResumableCubit Lifecycle

Cubits that need auto-refresh on app resume extend `ResumableCubit<S>` (Cubit + WidgetsBindingObserver) and override `onResumed()`. Used by home, blockList, userMeetings, profile cubits. See `examples/resumable-cubit-pattern.md`.

## Screen Conventions

| Convention | Implementation |
|------------|----------------|
| Controllers | `StatefulWidget` + `dispose()` |
| DI | `BlocProvider.create` + `context.read<T>()` |
| Navigation/Errors | `BlocConsumer.listener` + `context.go()` + SnackBar |
| Auto-load | Call loading method in cubit constructor |
| Data states | Single state class + status enum (`XxxStatus.success`) |

## Page/View Separation

```
*_page.dart    # Route entry, instantiates Cubit
*_view.dart    # Main widget via BlocBuilder
```

## 📂 Codebase References

**States/Cubits**: `lib/ui/{feature}/cubit/` (e.g. `lib/ui/meetings/userMeetings/cubit/`)
**Screens**: `lib/ui/{feature}/widgets/`
**Router**: `lib/routing/router.dart`, `lib/routing/routes.dart`
**DI**: `lib/config/dependencies.dart`

## Related Files

- `technical-domain.md` - Entry point
- `technical-api-pattern.md` - API patterns
