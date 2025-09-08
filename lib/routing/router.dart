import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';
import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:bloco_na_rua/ui/auth/login/widgets/login_screen.dart';
import 'package:bloco_na_rua/ui/auth/signUp/view_model/signup_viewmodel.dart';
import 'package:bloco_na_rua/ui/auth/signUp/widgets/signup_screen.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/carnivalBlock.dart';
import 'package:bloco_na_rua/ui/home/view_model/home_viewmodel.dart';
import 'package:bloco_na_rua/ui/home/widgets/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(IAuthRepository authRepository) => GoRouter(
  initialLocation: Routes.login,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return LoginScreen(
          viewModel: LoginViewModel(authRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) {
        return SignUpScreen(
          viewModel: SignUpViewModel(authRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return HomeScreen(
          viewModel: HomeViewModel(membersRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.carnivalBlock,
      builder: (context, state) {
        return const CarnivalBlockPage();
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<IAuthRepository>().isAuthenticated;
  if (!loggedIn) {
    if (state.matchedLocation == Routes.register) {
      return null;
    }
    return Routes.login;
  }

  if ([Routes.login, Routes.register].contains(state.matchedLocation)) {
    return Routes.home;
  }

  return null;
}
