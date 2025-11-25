import 'package:bloco_na_rua/data/repositories/base/repository_base.dart';
import 'package:bloco_na_rua/data/repositories/Meetings/iMeetings_repository.dart';
import 'package:bloco_na_rua/data/services/api/meetings/imeetings_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meeting_entity.dart';
import 'package:result_dart/result_dart.dart';

class MeetingsRepository extends RepositoryBase<MeetingEntity>
    implements IMeetingsRepository {
  MeetingsRepository({required this.meetingsApiClient})
    : super(
        client: meetingsApiClient.client,
        fromJsonFactory: MeetingEntity.fromJson,
      );

  final IMeetingsApiClient meetingsApiClient;

  @override
  AsyncResult<List<MeetingEntity>> getAllByBlockId(int id) async {
    return await meetingsApiClient.getAllByBlockId(id);
  }
}
