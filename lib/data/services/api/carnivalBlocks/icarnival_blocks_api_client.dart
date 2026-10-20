import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ICarnivalBlocksApiClient {
  IBaseApiClient get client;

  AsyncResult<CarnivalBlocksEntity> getByIdAsync(int id);

  AsyncResult<CarnivalBlocksEntity> getByInviteCodeAsync(String inviteCode);

  AsyncResult<List<CarnivalBlocksEntity>> getAllAsync();

  AsyncResult deleteAsync(int id);

  AsyncResult<TEntity> createAsync<TEntity extends EntityBase>(
    Map<String, dynamic> data,
    JsonFactory<TEntity> fromJsonFactory,
  );

  AsyncResult<CarnivalBlocksEntity> updateAsync(
    int id,
    Map<String, dynamic> data,
  );
}
