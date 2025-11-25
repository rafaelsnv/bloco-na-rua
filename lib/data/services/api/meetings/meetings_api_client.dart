import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/meetings/imeetings_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meeting_entity.dart';
import 'package:result_dart/result_dart.dart';

class MeetingsApiClient implements IMeetingsApiClient {
  final IBaseApiClient baseApiClient;
  late final String _basePath;

  MeetingsApiClient(this.baseApiClient) {
    _basePath = '${baseApiClient.basePath}meetings';
  }

  @override
  IBaseApiClient get client => baseApiClient;

  @override
  AsyncResult<List<MeetingEntity>> getAllByBlockId(int blockId) async {
    try {
      final response = await baseApiClient.client.get(
        '$_basePath/block/$blockId',
      );
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = await response.data as List;
      final result = data.map((e) => MeetingEntity.fromJson(e)).toList();
      return Success(result);
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }

  @override
  AsyncResult<List<MeetingEntity>> getAllByMemberId(String memberId) async {
    try {
      final response = await baseApiClient.client.get(
        '$_basePath/member/$memberId',
      );
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = await response.data as List;
      final result = data.map((e) => MeetingEntity.fromJson(e)).toList();
      return Success(result);
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }

  @override
  AsyncResult<void> confirmPresence(int meetingId, String memberId) async {
    try {
      final response = await baseApiClient.client.post(
        '$_basePath/$meetingId/confirm-presence/$memberId',
      );
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(unit);
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }

  @override
  AsyncResult<void> denyPresence(int meetingId, String memberId) async {
    try {
      final response = await baseApiClient.client.post(
        '$_basePath/$meetingId/deny-presence/$memberId',
      );
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(unit);
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }
}
