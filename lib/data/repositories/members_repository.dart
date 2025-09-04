import 'package:bloco_na_rua/data/repositories/base/repository_base.dart';
import 'package:bloco_na_rua/data/repositories/interfaces/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/members_entity.dart';

class MembersRepository extends RepositoryBase<MembersEntity>
    implements IMembersRepository {
  MembersRepository({required super.apiClient})
    : super(fromJsonFactory: MembersEntity.fromJson);
}
