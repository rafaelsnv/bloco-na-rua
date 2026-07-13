import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IMeetingPresencesApiClient {
  IBaseApiClient get client;

  /// Fetches all presence records for a given meeting.
  ///
  /// [meetingId] - The ID of the meeting to get presence records for.
  ///
  /// **HTTP Status Codes:**
  /// - `200 OK` - Presence records returned successfully
  /// - `404 Not Found` - No presence records exist for this meeting (returns empty list)
  AsyncResult<List<MeetingPresencesEntity>> getByMeetingId(int meetingId);

  /// Creates a presence record for a member at a meeting.
  ///
  /// The [data] map must contain:
  /// - `meetingId` - The ID of the meeting
  /// - `memberId` - The ID of the member
  /// - `isPresent` - Boolean indicating attendance:
  ///   - `true` - Member is marked as attending (present)
  ///   - `false` - Member is marked as not attending (absent)
  ///
  /// **HTTP Status Codes:**
  /// - `201 Created` - Presence record created successfully
  /// - `200 OK` - Presence record updated successfully
  /// - Error status codes - Request failed (see [ApiError])
  AsyncResult<MeetingPresencesEntity> createAsync(Map<String, dynamic> data);

  /// Deletes a presence record by its ID.
  ///
  /// [id] - The ID of the presence record to delete.
  ///
  /// **HTTP Status Codes:**
  /// - `204 No Content` - Presence record deleted successfully
  /// - Error status codes - Request failed (see [ApiError])
  AsyncResult deleteAsync(int id);
}
