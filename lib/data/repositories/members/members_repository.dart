import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart';
import 'package:bloco_na_rua/data/services/api/members/imembers_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:result_dart/result_dart.dart';

class MembersRepository implements IMembersRepository {
  MembersRepository({required IMembersApiClient membersApiClient})
    : _membersApiClient = membersApiClient;

  final IMembersApiClient _membersApiClient;

  @override
  AsyncResult<MembersEntity> createAsync(MemberCreate model) async {
    return await _membersApiClient.createAsync(model);
  }

  @override
  AsyncResult<MembersEntity> getByUuidAsync(String uuid) async {
    return await _membersApiClient.getByUuidAsync(uuid);
  }

  @override
  AsyncResult<List<CarnivalBlocksEntity>> getBlocksByMemberId(int id) async {
    return await _membersApiClient.getBlocksByMemberId(id);
  }

  @override
  AsyncResult<List<MeetingsEntity>> getMeetingsByMemberId(int id) async {
    return await _membersApiClient.getMeetingsByMemberId(id);
  }

  @override
  AsyncResult<List<MembersEntity>> getAllAsync() async {
    return await _membersApiClient.getAllAsync();
  }

  @override
  AsyncResult<MembersEntity> getByIdAsync(int id) async {
    return await _membersApiClient.getByIdAsync(id);
  }

  @override
  AsyncResult<MembersEntity> updateAsync(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await _membersApiClient.updateAsync(id, data);
  }

  @override
  AsyncResult deleteAsync(int id) async {
    return await _membersApiClient.deleteAsync(id);
  }
}
