import 'package:bloco_na_rua/data/services/api/members/create/member_create.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IMembersRepository {
  AsyncResult<MembersEntity> createAsync(MemberCreate model);
  AsyncResult<MembersEntity> getByUuidAsync(String uuid);
  AsyncResult<List<CarnivalBlocksEntity>> getBlocksByMemberId(int id);
  AsyncResult<List<MeetingsEntity>> getMeetingsByMemberId(int id);

  // Stub methods to satisfy the codebase - not actually used
  Future<Result<List<MembersEntity>>> getAllAsync() async => const Success([]);
  Future<Result<MembersEntity>> getByIdAsync(int id) async =>
      Failure(Exception('Not supported'));
  Future<Result> deleteByIdAsync(int id) async =>
      Failure(Exception('Not supported'));
}
