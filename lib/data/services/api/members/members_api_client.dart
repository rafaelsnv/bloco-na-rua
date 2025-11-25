import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/members/create/member_create.dart';
import 'package:bloco_na_rua/data/services/api/members/imembers_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meeting_entity.dart';
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
      final data = await response.data;
      final result = MembersEntity.fromJson(data as Map<String, dynamic>);
      return Success(result);
    } catch (error) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $error'));
    }
  }

  @override
  AsyncResult<MembersEntity> getByUuidAsync(String uuid) async {
    try {
      final response = await baseApiClient.client.get('$_basePath/uuid/$uuid');
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = await response.data;
      final result = MembersEntity.fromJson(data as Map<String, dynamic>);
      return Success(result);
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
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
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = await response.data as List;
      final result = data.map((e) => CarnivalBlocksEntity.fromJson(e)).toList();
      return Success(result);
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }

  @override
  AsyncResult<List<MeetingEntity>> getMeetingsByMemberId(int memberId) async {
    try {
      final response = await baseApiClient.client.get(
        '$_basePath/$memberId/meetings',
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
}
