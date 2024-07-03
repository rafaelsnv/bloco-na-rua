import 'dart:async';

import 'package:bloco_na_rua/src/features/auth/interactor/blocs/auth_bloc.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/states/auth_state.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppGuard extends RouteGuard {
  AppGuard() : super(redirectTo: '/');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    final state = Modular.get<AuthBloc>().state;
    return state is LoggedAuthState;
  }
}
