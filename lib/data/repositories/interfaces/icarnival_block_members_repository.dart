import 'package:bloco_na_rua/core/irepository_base.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ICarnivalBlockMembersRepository
    implements IRepositoryBase<CarnivalBlockMembersEntity> {
  AsyncResult<List<CarnivalBlockMembersEntity>> getByMemberIdAsync(int id);
}
