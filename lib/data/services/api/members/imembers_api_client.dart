import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/members/create/member_create.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract class IMembersApiClient {
  IBaseApiClient get client;
  AsyncResult<MembersEntity> createAsync(MemberCreate model);
  AsyncResult<MembersEntity> getByUuidAsync(String uuid);
  AsyncResult<List<CarnivalBlocksEntity>> getBlocksByMemberId(int memberId);
  AsyncResult<List<MeetingsEntity>> getMeetingsByMemberId(int memberId);
  AsyncResult<List<MembersEntity>> getAllAsync();
  AsyncResult<MembersEntity> getByIdAsync(int id);
  AsyncResult<MembersEntity> updateAsync(int id, Map<String, dynamic> data);
  AsyncResult deleteAsync(int id);
}
