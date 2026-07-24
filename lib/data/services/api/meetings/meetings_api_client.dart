import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/meetings/imeetings_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

class MeetingsApiClient implements IMeetingsApiClient {
  final IBaseApiClient baseApiClient;
  late final String _basePath;

  MeetingsApiClient(this.baseApiClient) {
    _basePath = '${baseApiClient.basePath}Meetings';
  }

  @override
  IBaseApiClient get client => baseApiClient;

  @override
  AsyncResult<MeetingsEntity> getByIdAsync(int id) async {
    try {
      final response = await baseApiClient.client.get('$_basePath/$id');
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(MeetingsEntity.fromJson(response.data));
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
  AsyncResult<List<MeetingsEntity>> getAllByBlockId(int blockId) async {
    try {
      final response = await baseApiClient.client.get(
        '$_basePath/block/$blockId',
      );
      final List<MeetingsEntity> result = [];
      switch (response.statusCode) {
        case 200:
          result.addAll(
            (response.data as List).map((e) => MeetingsEntity.fromJson(e)),
          );
        case 404:
          return Success(result);
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
  AsyncResult<MeetingsEntity> createAsync(Map<String, dynamic> data) async {
    try {
      final response = await baseApiClient.client.post(_basePath, data: data);
      if (response.statusCode != 201 && response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(MeetingsEntity.fromJson(response.data));
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
  AsyncResult<MeetingsEntity> updateAsync(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await baseApiClient.client.put(
        '$_basePath/$id',
        data: data,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(MeetingsEntity.fromJson(response.data));
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

  @override
  AsyncResult<List<MeetingsEntity>> getAllAsync() async {
    try {
      final response = await baseApiClient.client.get(_basePath);
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = response.data as List;
      final result = data.map((e) => MeetingsEntity.fromJson(e)).toList();
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
}
