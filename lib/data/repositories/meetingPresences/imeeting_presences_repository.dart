import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IMeetingPresencesRepository {
  AsyncResult<List<MeetingPresencesEntity>> getAllAsync();

  AsyncResult<MeetingPresencesEntity> getByIdAsync(int id);

  AsyncResult deleteByIdAsync(int id);

  /// Creates a presence record with optional idempotency key.
  ///
  /// [idempotencyKey] - Optional unique key (e.g., `${memberId}_${meetingId}`)
  /// to prevent duplicate records on rapid calls/retry.
  AsyncResult<MeetingPresencesEntity> createAsync(
    Map<String, dynamic> data, {
    String? idempotencyKey,
  });

  AsyncResult<MeetingPresencesEntity> updateAsync(
    int id,
    Map<String, dynamic> data,
  );

  AsyncResult<List<MeetingPresencesEntity>> getByMeetingId(int meetingId);
}
