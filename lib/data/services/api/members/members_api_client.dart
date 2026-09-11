import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart'
    show MemberCreate, MemberResponse;
import 'package:bloco_na_rua/data/services/api/members/imembers_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

class MembersApiClient implements IMembersApiClient {
  final IBaseApiClient baseApiClient;
  late final String _basePath;

  MembersApiClient(this.baseApiClient) {
    _basePath = '${baseApiClient.basePath}Members';
  }

  @override
  IBaseApiClient get client => baseApiClient;

  @override
  AsyncResult<MembersEntity> createAsync(MemberCreate model) async {
    try {
      final body = model.toJson();
      final response = await baseApiClient.client.post(_basePath, data: body);
      if (response.statusCode != 201) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = response.data;
      if (data == null) {
        return Failure(ApiError(
          type: ApiErrorType.unknown,
          userMessage: 'Unexpected empty response from server',
          technicalMessage: 'API returned 201 with null body',
        ));
      }
      // Use swagger-generated MemberResponse model
      final memberResponse = MemberResponse.fromJson(data as Map<String, dynamic>);
      // Convert to domain entity
      final result = MembersEntity(
        id: memberResponse.id ?? 0,
        name: memberResponse.name,
        email: memberResponse.email,
        phone: memberResponse.phone,
        profileImage: memberResponse.profileImage,
        uuid: memberResponse.uuid,
        createdAt: memberResponse.createdAt,
        updatedAt: memberResponse.updatedAt,
      );
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
  AsyncResult<MembersEntity> getByUuidAsync(String uuid) async {
    try {
      final response = await baseApiClient.client.get('$_basePath/uuid/$uuid');
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = response.data;
      // Handle null/empty response (soft 404 from backend)
      if (data == null) {
        return Failure(ApiError(
          type: ApiErrorType.notFound,
          userMessage: 'Member not found',
          technicalMessage: 'API returned 200 with null body for uuid: $uuid',
        ));
      }
      // Use swagger-generated MemberResponse model
      final memberResponse = MemberResponse.fromJson(data as Map<String, dynamic>);
      // Convert to domain entity
      final result = MembersEntity(
        id: memberResponse.id ?? (throw Exception('Missing id in MemberResponse')),
        name: memberResponse.name,
        email: memberResponse.email,
        phone: memberResponse.phone,
        profileImage: memberResponse.profileImage,
        uuid: memberResponse.uuid,
        createdAt: memberResponse.createdAt,
        updatedAt: memberResponse.updatedAt,
      );
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
  AsyncResult<List<CarnivalBlocksEntity>> getBlocksByMemberId(
    int memberId,
  ) async {
    try {
      final response = await baseApiClient.client.get(
        '$_basePath/$memberId/blocks',
      );
      List<CarnivalBlocksEntity> result = [];
      switch (response.statusCode) {
        case 200:
          final data = await response.data as List;
          result = data.map((e) => CarnivalBlocksEntity.fromJson(e)).toList();
        case 404:
          // Member has no blocks - return empty list
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
  AsyncResult<List<MeetingsEntity>> getMeetingsByMemberId(int memberId) async {
    try {
      final response = await baseApiClient.client.get(
        '$_basePath/$memberId/meetings',
      );
      List<MeetingsEntity> result = [];
      switch (response.statusCode) {
        case 200:
          final data = await response.data as List;
          result = data.map((e) => MeetingsEntity.fromJson(e)).toList();
        case 404:
          // Member has no meetings - return empty list
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
  AsyncResult<List<MembersEntity>> getAllAsync() async {
    try {
      final response = await baseApiClient.client.get(_basePath);
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = response.data as List;
      final result = data.map((e) => MembersEntity.fromJson(e)).toList();
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
  AsyncResult<MembersEntity> getByIdAsync(int id) async {
    try {
      final response = await baseApiClient.client.get('$_basePath/$id');
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = response.data;
      final result = MembersEntity.fromJson(data as Map<String, dynamic>);
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
  AsyncResult<MembersEntity> updateAsync(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await baseApiClient.client.put(
        '$_basePath/$id',
        data: data,
      );
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final responseData = response.data;
      final result = MembersEntity.fromJson(
        responseData as Map<String, dynamic>,
      );
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
  AsyncResult deleteAsync(int id) async {
    try {
      final response = await baseApiClient.client.delete('$_basePath/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(response.statusCode!);
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
