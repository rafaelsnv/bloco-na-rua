import 'package:bloco_na_rua/data/repositories/base/repository_base.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/data/services/api/meetings/imeetings_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:result_dart/result_dart.dart';

class MeetingsRepository extends RepositoryBase<MeetingsEntity>
    implements IMeetingsRepository {
  MeetingsRepository({required this.meetingsApiClient})
    : super(
        client: meetingsApiClient.client,
        fromJsonFactory: MeetingsEntity.fromJson,
      );

  final IMeetingsApiClient meetingsApiClient;

  @override
  AsyncResult<List<MeetingsEntity>> getAllByBlockId(int id) async {
    return await meetingsApiClient.getAllByBlockId(id);
  }
}
