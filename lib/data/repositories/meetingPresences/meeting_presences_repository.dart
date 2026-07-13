import 'package:bloco_na_rua/data/repositories/meetingPresences/imeeting_presences_repository.dart';
import 'package:bloco_na_rua/data/services/api/meetingPresences/imeeting_presences_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:result_dart/result_dart.dart';

class MeetingPresencesRepository implements IMeetingPresencesRepository {
  MeetingPresencesRepository({required this.meetingPresencesApiClient});

  final IMeetingPresencesApiClient meetingPresencesApiClient;

  @override
  AsyncResult<List<MeetingPresencesEntity>> getByMeetingId(
    int meetingId,
  ) async {
    return await meetingPresencesApiClient.getByMeetingId(meetingId);
  }

  @override
  AsyncResult<MeetingPresencesEntity> createAsync(
    Map<String, dynamic> data,
  ) async {
    return await meetingPresencesApiClient.createAsync(data);
  }

  // Implement required IRepositoryBase methods using base repo pattern
  @override
  AsyncResult<List<MeetingPresencesEntity>> getAllAsync() async {
    // TODO(backend): implement list-all endpoint or confirm no list-all operation exists
    return Failure(
      Exception(
        'List-all not implemented: use getByMeetingId for specific meetings',
      ),
    );
  }

  @override
  AsyncResult<MeetingPresencesEntity> getByIdAsync(int id) async {
    // TODO(backend): implement getById endpoint if needed
    return Failure(Exception(UnimplementedError()));
  }

  @override
  AsyncResult deleteByIdAsync(int id) async {
    return await meetingPresencesApiClient.deleteAsync(id);
  }
}
