import 'package:bloco_na_rua/src/features/carnival_block/interactor/entities/carnival_block_entity.dart';

class CarnivalBlockAdapter {
  static CarnivalBlockEntity fromFireStoreRepository(
    Map<String, dynamic> data,
  ) {
    return CarnivalBlockEntity(
      name: data['name'],
      owner: data['owner'],
    );
  }
}
