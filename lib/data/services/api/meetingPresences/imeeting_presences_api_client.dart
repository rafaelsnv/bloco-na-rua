import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IMeetingPresencesApiClient {
  IBaseApiClient get client;

  // GET /api/v1/MeetingPresences/meeting/{meetingId}
  AsyncResult<List<MeetingPresencesEntity>> getByMeetingId(int meetingId);

  // POST /api/v1/MeetingPresences
  AsyncResult<MeetingPresencesEntity> createAsync(Map<String, dynamic> data);

  // DELETE /api/v1/MeetingPresences/{id}
  AsyncResult deleteAsync(int id);
}
