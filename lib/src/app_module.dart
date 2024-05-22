import 'package:bloco_na_rua/src/features/auth/data/services/firebase_auth_service.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/blocs/auth_bloc.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/services/iauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'features/auth/ui/login_page.dart';
import 'features/home/ui/pages/home_page.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i..addInstance<FirebaseAuth>(FirebaseAuth.instance)
    ..add<IAuthService>(FirebaseAuthService.new)
    ..addSingleton<AuthBloc>(AuthBloc.new);
  
  }

  @override
  void routes(RouteManager r) {
    r..child('/', child: (context) => const HomePage())
    ..child('/login', child: (context) => const LoginPage());
  }
}