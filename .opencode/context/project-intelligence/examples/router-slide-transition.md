<!-- Context: project-intelligence/examples/router-slide-transition | Priority: medium | Version: 1.0 | Updated: 2026-07-02 -->

# Router — Slide Transition + BlocProvider Pattern

**Core Concept**: All screens use a custom left-to-right slide transition via `CustomTransitionPage<T>`. Page-scoped Cubits are created via `BlocProvider(create: ...)` inside the route's `pageBuilder`.

---

## The Slide Helper

`lib/routing/router.dart`:

```dart
CustomTransitionPage<void> _buildPageWithSlideTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0), // start off-screen right
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      );
    },
  );
}
```

**Behavior**: Routes slide in from the right (push), standard mobile pattern.

---

## Standard Route Pattern

```dart
GoRoute(
  path: Routes.profile,           // = '/profile'
  pageBuilder: (context, state) => _buildPageWithSlideTransition(
    context: context,
    state: state,
    child: BlocProvider(
      create: (context) => context.read<ProfileCubit>()..loadProfile(),
      child: const ProfileScreen(),
    ),
  ),
),
```

---

## Detail Route (with path parameter)

```dart
GoRoute(
  path: '${Routes.meeting}/:id',    // = '/meeting/:id'
  pageBuilder: (context, state) {
    final meetingId = state.pathParameters['id']!;
    return _buildPageWithSlideTransition(
      context: context,
      state: state,
      child: BlocProvider(
        create: (context) => MeetingDetailsCubit(
          meetingsRepository: context.read<IMeetingsRepository>(),
          meetingPresencesRepository:
              context.read<IMeetingPresencesRepository>(),
          authRepository: context.read<IAuthRepository>(),
          carnivalBlocksRepository:
              context.read<ICarnivalBlocksRepository>(),
          meetingId: meetingId,
        ),
        child: MeetingDetailsScreen(meetingId: meetingId),
      ),
    );
  },
),
```

---

## No-Transition Routes (auth + error)

```dart
GoRoute(
  path: Routes.login,
  builder: (context, state) => const LoginScreen(),
),
// no pageBuilder, no _buildPageWithSlideTransition → default transition
```

---

## Redirect Logic

```dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final sessionValid =
      await context.read<IAuthRepository>().validateSession();
  final location = state.matchedLocation;

  if (!sessionValid && location != Routes.register) {
    return Routes.login;
  }
  if (sessionValid &&
      [Routes.login, Routes.register].contains(location)) {
    return Routes.home;
  }
  return null;  // no redirect
}
```

**Refresh trigger**: `refreshListenable: authRepository` — when the repo notifies (login/logout), GoRouter re-evaluates redirects.

---

## Error Builder

```dart
errorBuilder: (context, state) {
  final error = state.error;
  if (error != null && error.toString().contains('not found')) {
    _logger.warning('Page not found: ${state.uri}');
    return const NotFoundScreen();
  }
  _logger.severe('Routing error: $error', error, StackTrace.current);
  return const ErrorScreen();
},
```

---

## Anti-Patterns

| Pitfall                                                     | Better                                    |
| ----------------------------------------------------------- | ----------------------------------------- |
| Pass `BlocProvider` via constructor                         | Use `BlocProvider(create:)` in route       |
| Create global Cubit for per-page state                       | Page-scoped creates → auto-dispose         |
| Use `Builder` instead of `BlocBuilder`                       | `BlocBuilder<MyCubit, MyState>` typed       |
| Forget `key: state.pageKey`                                 | Required for transition back-stack       |
| Disable `refreshListenable` on auth                         | Logout won't redirect from `/home` → `/login` |
| Forget `redirect` returning `null`                          | Routes will infinite-loop                  |

---

## Reference

- `lib/routing/router.dart` — full route list
- `lib/routing/routes.dart` — path constants
- `lookup/routes.md` — full catalog
- `go_router` docs: https://pub.dev/packages/go_router
