<!-- Context: project-intelligence/examples/module-pattern | Priority: high | Version: 2.0 | Updated: 2026-11-17 -->

# Feature Wiring Pattern

**Core Concept**: This project does NOT use flutter_modular. Features are wired with plain GoRouter routes (`lib/routing/router.dart`) plus Provider-based DI (`lib/config/dependencies.dart`).

---

## 1. DI Registration (Provider chain)

Register API client → repository → use case in `lib/config/dependencies.dart`:

```dart
// API client (thin HTTP wrapper)
Provider<IMeetingsApiClient>(
  create: (context) => MeetingsApiClient(context.read<IBaseApiClient>()),
),
// Repository (domain-facing interface)
Provider<IMeetingsRepository>(
  create: (context) =>
      MeetingsRepository(meetingsApiClient: context.read()),
),
// Use case (consumed by cubits)
Provider<GetUserMeetingsUseCase>(
  create: (context) => GetUserMeetingsUseCase(
    getCurrentUserData: context.read(),
    membersRepo: context.read(),
  ),
),
```

---

## 2. Route + BlocProvider

Register the route in `lib/routing/router.dart`; create the cubit in `pageBuilder`:

```dart
GoRoute(
  path: "${Routes.carnivalBlock}/:id",
  pageBuilder: (context, state) {
    final carnivalBlockId = state.pathParameters["id"]!;
    return _buildPageWithSlideTransition(
      context: context,
      state: state,
      child: BlocProvider(
        create: (context) => BlockDetailsCubit(
          carnivalBlocksRepository: context.read<ICarnivalBlocksRepository>(),
          getCurrentUserData: context.read<GetCurrentUserData>(),
          carnivalBlockId: carnivalBlockId,
        ),
        child: BlockDetailsScreen(carnivalBlockId: carnivalBlockId),
      ),
    );
  },
),
```

---

## Key Points

1. `Provider<T>` registered against an **interface** (`IMeetingsRepository`), resolved with `context.read<T>()`
2. Cubits are created per-route in `pageBuilder` via `BlocProvider(create: ...)`, not registered in DI
3. Detail routes use `_buildPageWithSlideTransition` for the shared slide animation
4. Route path constants live in `lib/routing/routes.dart`
5. There are no Modules, no `Bind`, no `ModularRoute` anywhere in this codebase

---

## Reference

- DI: `lib/config/dependencies.dart`
- Routing: `lib/routing/router.dart`, `lib/routing/routes.dart`
- Resumable lifecycle cubits: `examples/resumable-cubit-pattern.md`
