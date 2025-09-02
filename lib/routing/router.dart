import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'package:bloco_na_rua/data/repositories/auth_repository.dart';
import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/members_list_screen.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: Routes.members,
  routes: [
    GoRoute(
      path: Routes.members,
      builder: (context, state) => const MembersListScreen(),
    ),
  ],
);

GoRouter routerAuth(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return const MembersListScreen();
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}
