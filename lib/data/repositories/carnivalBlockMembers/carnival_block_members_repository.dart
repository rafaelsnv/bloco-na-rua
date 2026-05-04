import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlockMembers/icarnival_block_members_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:result_dart/result_dart.dart';

class CarnivalBlockMembersRepository
    implements ICarnivalBlockMembersRepository {
  CarnivalBlockMembersRepository({required this.carnivalBlockMembersApiClient});

  final ICarnivalBlockMembersApiClient carnivalBlockMembersApiClient;

  @override
  AsyncResult<List<CarnivalBlockMembersEntity>> getByMemberIdAsync(
    int id,
  ) async {
    return await carnivalBlockMembersApiClient.getByBlockIdAsync(id);
  }

  @override
  AsyncResult<CarnivalBlockMembersEntity> createAsync(
    int carnivalBlockId,
    int memberId,
    int role,
  ) async {
    return await carnivalBlockMembersApiClient.createAsync(
      carnivalBlockId,
      memberId,
      role,
    );
  }

  @override
  AsyncResult<CarnivalBlockMembersEntity> updateAsync(
    int id,
    int carnivalBlockId,
    int memberId,
    int role,
  ) async {
    return await carnivalBlockMembersApiClient.updateAsync(
      id,
      carnivalBlockId,
      memberId,
      role,
    );
  }

  @override
  AsyncResult<void> deleteAsync(int id, int memberId) async {
    return await carnivalBlockMembersApiClient.deleteAsync(id, memberId);
  }
}
