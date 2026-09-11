import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/meetingPresences/imeeting_presences_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:dio/dio.dart';
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
        '$_basePath/$meetingId',
      );
      final List<MeetingPresencesEntity> result = [];
      switch (response.statusCode) {
        case 200:
          if (response.data is List) {
            result.addAll(
              (response.data as List<dynamic>).map(
                (e) => MeetingPresencesEntity.fromJson(e as Map<String, dynamic>),
              ),
            );
          } else {
            result.add(MeetingPresencesEntity.fromJson(response.data));
          }
        case 404:
          // No presences for this meeting - return empty list
          break;
        default:
          return Failure(baseApiClient.formatError(response));
      }
      return Success(result);
    } on DioException catch (e) {
      return Failure(ApiError.fromDioException(e));
    } catch (e) {
      return Failure(ApiError(
        type: ApiErrorType.unknown,
        userMessage: 'Something unexpected happened. Try again.',
        technicalMessage: e.toString(),
      ));
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
      return Success(MeetingPresencesEntity.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure(ApiError.fromDioException(e));
    } catch (e) {
      return Failure(ApiError(
        type: ApiErrorType.unknown,
        userMessage: 'Something unexpected happened. Try again.',
        technicalMessage: e.toString(),
      ));
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
    } on DioException catch (e) {
      return Failure(ApiError.fromDioException(e));
    } catch (e) {
      return Failure(ApiError(
        type: ApiErrorType.unknown,
        userMessage: 'Something unexpected happened. Try again.',
        technicalMessage: e.toString(),
      ));
    }
  }
}
