import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/meetingPresences/imeeting_presences_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:result_dart/result_dart.dart';

class MeetingPresencesApiClient implements IMeetingPresencesApiClient {
  final IBaseApiClient baseApiClient;
  late final String _basePath;

  MeetingPresencesApiClient(this.baseApiClient) {
    _basePath = '${baseApiClient.basePath}MeetingPresences';
  }

  @override
  IBaseApiClient get client => baseApiClient;

  @override
  AsyncResult<List<MeetingPresencesEntity>> getByMeetingId(
    int meetingId,
  ) async {
    try {
      final response = await baseApiClient.client.get(
        '$_basePath/meeting/$meetingId',
      );
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = await response.data as List<dynamic>;
      final result = data
          .map((e) => MeetingPresencesEntity.fromJson(e))
          .toList();
      return Success(result);
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }

  @override
  AsyncResult<MeetingPresencesEntity> createAsync(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await baseApiClient.client.post(_basePath, data: data);
      if (response.statusCode != 201 && response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(MeetingPresencesEntity.fromJson(response.data));
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }

  @override
  AsyncResult deleteAsync(int id) async {
    try {
      final response = await baseApiClient.client.delete('$_basePath/$id');
      if (response.statusCode != 204) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(response.statusCode.toString());
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }
}
