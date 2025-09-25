import 'package:bloco_na_rua/core/irepository_base.dart';
import 'package:bloco_na_rua/data/services/api/members/create/member_create.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IMembersRepository
    implements IRepositoryBase<MembersEntity> {
  AsyncResult<MembersEntity> createAsync(MemberCreate model);
}
