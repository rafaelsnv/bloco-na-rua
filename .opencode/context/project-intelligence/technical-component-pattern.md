<!-- Context: project-intelligence/technical-component | Priority: high | Version: 1.0 | Updated: 2026-05-17 -->

# Component Patterns

**Purpose**: State, cubit, screen, and router patterns.
**Audience**: AI agents implementing Flutter UI with BLoC

## State Pattern

```dart
sealed class CreateEntityState extends Equatable {
  const CreateEntityState();
  @override List<Object?> get props => [];
}
final class CreateEntityInitial extends CreateEntityState {}
final class CreateEntityLoading extends CreateEntityState {}
final class CreateEntitySuccess extends CreateEntityState {}
final class CreateEntityError extends CreateEntityState {
  final String message;
  const CreateEntityError(this.message);
  @override List<Object?> get props => [message];
}
final class EditEntityLoaded extends CreateEntityState {
  final int id;
  final String name;
  const EditEntityLoaded({required this.id, required this.name});
}
```

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

```dart
GoRouter router(IAuthRepository authRepository) => GoRouter(
  initialLocation: Routes.login,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: '${Routes.editEntity}/:id',
      builder: (ctx, state) => BlocProvider(
        create: (ctx) => EditEntityCubit(
          repo: ctx.read<IEntityRepository>(),
          entityId: state.pathParameters['id']!,
        ),
        child: const EditEntityScreen(),
      ),
    ),
  ],
);

Future<String?> _redirect(BuildContext ctx, GoRouterState state) async {
  final loggedIn = await ctx.read<IAuthRepository>().isAuthenticated;
  if (!loggedIn && state.matchedLocation != Routes.register) return Routes.login;
  if (loggedIn && [Routes.login, Routes.register].contains(state.matchedLocation)) return Routes.home;
  return null;
}
```

## Screen Conventions

| Convention | Implementation |
|------------|----------------|
| Controllers | `StatefulWidget` + `dispose()` |
| DI | `BlocProvider.create` + `context.read<T>()` |
| Navigation/Errors | `BlocConsumer.listener` + `context.go()` + SnackBar |
| Auto-load | Call loading method in cubit constructor |
| Data states | Extended states (`XxxLoaded extends XxxState`) |

## Page/View Separation

```
*_page.dart    # Route entry, instantiates Cubit
*_view.dart    # Main widget via BlocBuilder
```

## 📂 Codebase References

**States**: `lib/domain/states/`
**Cubits**: `lib/domain/cubits/`
**Screens**: `lib/ui/screens/`
**Router**: `lib/ui/router/app_router.dart`

## Related Files

- `technical-domain.md` - Entry point
- `technical-api-pattern.md` - API patterns
