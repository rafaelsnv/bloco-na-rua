import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlockMembers/icarnival_block_members_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

class CarnivalBlockMembersApiClient implements ICarnivalBlockMembersApiClient {
  final IBaseApiClient baseApiClient;
  late final String _basePath;

  CarnivalBlockMembersApiClient(this.baseApiClient) {
    _basePath = '${baseApiClient.basePath}CarnivalBlockMembers';
  }

  @override
  IBaseApiClient get client => baseApiClient;

  @override
  AsyncResult<List<CarnivalBlockMembersEntity>> getByBlockIdAsync(
    int id,
  ) async {
    try {
      final response = await baseApiClient.client.get('$_basePath/block/$id');
      final List<CarnivalBlockMembersEntity> result = [];
      switch (response.statusCode) {
        case 200:
          result.addAll(
            (response.data as List<dynamic>).map(
              (e) => CarnivalBlockMembersEntity.fromJson(e),
            ),
          );
        case 404:
          // No members in this block - return empty list
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
  AsyncResult<CarnivalBlockMembersEntity> createAsync(
    int carnivalBlockId,
    int memberId,
    int role,
  ) async {
    try {
      final data = {
        'carnivalBlockId': carnivalBlockId,
        'role': role,
      };
      final response = await baseApiClient.client.post(
        _basePath,
        data: data,
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(CarnivalBlockMembersEntity.fromJson(response.data));
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
  AsyncResult<CarnivalBlockMembersEntity> updateAsync(
    int id,
    int carnivalBlockId,
    int memberId,
    int role,
  ) async {
    try {
      final data = {
        'carnivalBlockId': carnivalBlockId,
        'role': role,
      };
      final response = await baseApiClient.client.put(
        '$_basePath/$id',
        data: data,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(CarnivalBlockMembersEntity.fromJson(response.data));
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
  AsyncResult deleteAsync(int id, int memberId) async {
    try {
      final response = await baseApiClient.client.delete(
        '$_basePath/$id',
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
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
