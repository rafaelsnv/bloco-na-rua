import 'package:flutter_modular/flutter_modular.dart';
import 'features/auth/login_page.dart';
import 'features/home/ui/pages/home_page.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r..child('/', child: (context) => const HomePage())
    ..child('/login', child: (context) => const LoginPage());
  }
}
