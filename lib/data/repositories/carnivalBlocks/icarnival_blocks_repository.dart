import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ICarnivalBlocksRepository {
  AsyncResult<List<CarnivalBlocksEntity>> getAllAsync();

  AsyncResult<CarnivalBlocksEntity> getByIdAsync(int id);

  AsyncResult deleteByIdAsync(int id);

  AsyncResult<CarnivalBlocksEntity> createAsync(Map<String, dynamic> data);

  AsyncResult<CarnivalBlocksEntity> updateAsync(
    int id,
    Map<String, dynamic> data,
  );

  AsyncResult<CarnivalBlocksEntity> getByInviteCodeAsync(String inviteCode);
}
