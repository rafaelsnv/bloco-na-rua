import 'package:bloco_na_rua/src/features/auth/data/services/firebase_auth_service.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/blocs/auth_bloc.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/services/iauth_service.dart';
import 'package:bloco_na_rua/src/features/auth/ui/pages/login_page.dart';
import 'package:bloco_na_rua/src/features/auth/ui/pages/profile_page.dart';
import 'package:bloco_na_rua/src/features/auth/ui/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i
      ..addInstance<FirebaseAuth>(FirebaseAuth.instance)
      ..add<IAuthService>(FirebaseAuthService.new)
      ..addSingleton<AuthBloc>(AuthBloc.new);
  }

  @override
  void routes(RouteManager r) {
    r
      ..child('/auth/login', child: (context) => const LoginPage())
      ..child('/auth/profile', child: (context) => const ProfilePage())
      ..child('/auth/sign_up', child: (context) => const SignUpPage());
  }
}
