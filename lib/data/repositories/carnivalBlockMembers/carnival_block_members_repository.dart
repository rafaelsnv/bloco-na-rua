import 'package:bloco_na_rua/data/repositories/base/repository_base.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlockMembers/icarnival_block_members_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:result_dart/result_dart.dart';

class CarnivalBlockMembersRepository
    extends RepositoryBase<CarnivalBlockMembersEntity>
    implements ICarnivalBlockMembersRepository {
  CarnivalBlockMembersRepository({required this.carnivalBlockMembersApiClient})
    : super(
        client: carnivalBlockMembersApiClient.client,
        fromJsonFactory: CarnivalBlockMembersEntity.fromJson,
      );

  final ICarnivalBlockMembersApiClient carnivalBlockMembersApiClient;

  @override
  AsyncResult<List<CarnivalBlockMembersEntity>> getByMemberIdAsync(
    int id,
  ) async {
    return await carnivalBlockMembersApiClient.getByBlockIdAsync(id);
  }
}
