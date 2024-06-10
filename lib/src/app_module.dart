import 'package:bloco_na_rua/src/features/auth/auth_module.dart';
import 'package:bloco_na_rua/src/features/carnival_block/carnival_block_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_storage/get_storage.dart';
import 'features/home/ui/pages/home_page.dart';

class AppModule extends Module {

  @override
  void binds(Injector i) {
    super.binds(i);
    i.addInstance(GetStorage());
  }

  @override
  List<Module> get imports => [
        AuthModule(),
        CarnivalBlockModule(),
      ];

  @override
  void routes(RouteManager r) {
    r
      ..child('/', child: (context) => const HomePage())
      ..module('/', module: AuthModule())
      ..module('/', module: CarnivalBlockModule());
  }
}
