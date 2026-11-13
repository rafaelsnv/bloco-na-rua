<!-- Context: development/guides/flutter-routing | Priority: high | Version: 1.0 | Updated: 2026-06-14 -->

# Guide: go_router Navigation Pattern

**Purpose**: Auth-aware routing with go_router in Flutter.

---

## Route Constants

```dart
class Routes {
  Routes._();  // Private constructor - static only

  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String settings = '/settings';
  // Dynamic routes use :param syntax
  // e.g., '/meeting/:id' matches '/meeting/123'
}
```

---

## Router Setup

```dart
GoRouter router(IAuthRepository authRepository) => GoRouter(
  initialLocation: Routes.login,
  redirect: _redirect,
  refreshListenable: authRepository,
  errorBuilder: (context, state) => const ErrorScreen(),
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => BlocProvider(
        create: (ctx) => HomeCubit(repo: ctx.read())..load(),
        child: const HomeScreen(),
      ),
    ),
    // Dynamic route example
    GoRoute(
      path: '/entity/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (ctx) => EntityCubit(repo: ctx.read(), id: id),
            child: EntityScreen(id: id),
          ),
        );
      },
    ),
  ],
);
```

---

## Auth Redirect Pattern

```dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final sessionValid = await context.read<IAuthRepository>().validateSession();
  final location = state.matchedLocation;

  if (!sessionValid) {
    // Redirect to login for non-auth routes
    if (location != Routes.register) {
      return Routes.login;
    }
  }

  // Redirect authenticated users away from auth pages
  if ([Routes.login, Routes.register].contains(location)) {
    return Routes.home;
  }

  return null;  // No redirect
}
```

---

## Custom Page Transition

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
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
  );
}
```

---

## Key Points

1. **Route constants** - Centralize route strings
2. **Auth guard** - Validate session on every navigation
3. **refreshListenable** - Re-evaluate routes on auth changes
4. **Dynamic params** - Use `state.pathParameters['id']`
5. **Page transitions** - Use `pageBuilder` for custom animations

---

## Reference

- `lib/routing/router.dart` - Full implementation
- `lib/routing/routes.dart` - Route constants
