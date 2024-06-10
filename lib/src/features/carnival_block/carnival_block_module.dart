import 'package:bloco_na_rua/src/features/carnival_block/data/firestore_carnival_block_repository.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/blocs/carnival_block_bloc.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/repositories/icarnival_block_repository.dart';
import 'package:bloco_na_rua/src/features/carnival_block/ui/pages/create_block_page.dart';
import 'package:bloco_na_rua/src/features/carnival_block/ui/pages/view_block_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CarnivalBlockModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i
      ..addInstance<FirebaseFirestore>(FirebaseFirestore.instance)
      ..add<ICarnivalBlockRepository>(FirestoreCarnivalBlockRepository.new)
      ..addSingleton<CarnivalBlockBloc>(CarnivalBlockBloc.new);
  }

  @override
  void routes(RouteManager r) {
    r
      ..child(
        '/block/view_block',
        child: (context) => const ViewBlockPage(),
      )
      ..child(
        '/block/create_block',
        child: (context) => const CreateBlockPage(),
      );
  }
}
