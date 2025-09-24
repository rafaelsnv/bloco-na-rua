import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/members/create/member_create.dart';
import 'package:bloco_na_rua/domain/entities/members_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract class IMembersApiClient {
  IBaseApiClient get client;
  AsyncResult<MembersEntity> createAsync(MemberCreate model);
}
