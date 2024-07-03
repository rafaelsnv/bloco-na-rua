import 'package:bloco_na_rua/src/features/carnival_block/interactor/entities/carnival_block_entity.dart';

class CarnivalBlockAdapter {
  static CarnivalBlockEntity fromFireStoreRepository(
    Map<String, dynamic> data,
  ) {
    final managersCode = data['managers_code'];
    final inviteCode = data['invite_code'];
    final name = data['name'];
    final owner = data['owner'];
    final meetings = List<Map<String, dynamic>>.from(data['meetings']);
    final managers = List<Map<String, dynamic>>.from(data['managers']);
    final percussion = List<Map<String, dynamic>>.from(data['percussion']);

    return CarnivalBlockEntity(
      managersCode: managersCode,
      inviteCode: inviteCode,
      name: name,
      owner: owner,
      managers: managers,
      meetings: meetings,
      percussion: percussion,
    );
  }
}
