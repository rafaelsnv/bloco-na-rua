import 'package:bloco_na_rua/src/features/carnival_block/interactor/entities/carnival_block_entity.dart';

class CarnivalBlockAdapter {
  static CarnivalBlockEntity fromFireStoreRepository(
    Map<String, dynamic> data,
  ) {
    final inviteCode = data['invite_code'];
    final name = data['name'];
    final owner = data['owner'];
    final managers = data['managers'];
    final percussion = data['percussion'];

    return CarnivalBlockEntity(
      inviteCode: inviteCode,
      name: name,
      owner: owner,
      managers: managers,
      percussion: percussion,
    );
  }
}
