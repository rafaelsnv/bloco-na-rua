import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ICarnivalBlockMembersRepository {
  AsyncResult<List<CarnivalBlockMembersEntity>> getByBlockIdAsync(int blockId);
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
  AsyncResult<void> deleteAsync(int id, int memberId);
}
