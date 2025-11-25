import 'package:bloco_na_rua/data/repositories/base/repository_base.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/data/services/api/members/create/member_create.dart';
import 'package:bloco_na_rua/data/services/api/members/imembers_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meeting_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:result_dart/result_dart.dart';

class MembersRepository extends RepositoryBase<MembersEntity>
    implements IMembersRepository {
  MembersRepository({required this.membersApiClient})
    : super(
        client: membersApiClient.client,
        fromJsonFactory: MembersEntity.fromJson,
      );

  final IMembersApiClient membersApiClient;

  @override
  AsyncResult<MembersEntity> createAsync(MemberCreate model) async {
    return await membersApiClient.createAsync(model);
  }

  @override
  AsyncResult<MembersEntity> getByUuidAsync(String uuid) async {
    return await membersApiClient.getByUuidAsync(uuid);
  }

  @override
  AsyncResult<List<CarnivalBlocksEntity>> getBlocksByMemberId(int id) async {
    return await membersApiClient.getBlocksByMemberId(id);
  }

  @override
  AsyncResult<List<MeetingEntity>> getMeetingsByMemberId(int id) async {
    return await membersApiClient.getMeetingsByMemberId(id);
  }
}
