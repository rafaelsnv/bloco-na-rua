import 'package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IMembersRepository {
  AsyncResult<MembersEntity> createAsync(MemberCreate model);
  AsyncResult<MembersEntity> getByUuidAsync(String uuid);
  AsyncResult<List<CarnivalBlocksEntity>> getBlocksByMemberId(int id);
  AsyncResult<List<MeetingsEntity>> getMeetingsByMemberId(int id);
  AsyncResult<List<MembersEntity>> getAllAsync();
  AsyncResult<MembersEntity> getByIdAsync(int id);
  AsyncResult<MembersEntity> updateAsync(int id, Map<String, dynamic> data);
  AsyncResult deleteAsync(int id);
}
