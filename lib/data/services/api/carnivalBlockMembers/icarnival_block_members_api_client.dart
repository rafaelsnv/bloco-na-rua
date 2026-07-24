import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ICarnivalBlockMembersApiClient {
  IBaseApiClient get client;
  AsyncResult<List<CarnivalBlockMembersEntity>> getByBlockIdAsync(int id);
  AsyncResult<CarnivalBlockMembersEntity> createAsync(
    int carnivalBlockId,
    int memberId,
    int role,
  );
  AsyncResult<CarnivalBlockMembersEntity> updateAsync(
    int id,
    int carnivalBlockId,
    int memberId,
    int role,
  );
  AsyncResult deleteAsync(int id, int memberId);
}
