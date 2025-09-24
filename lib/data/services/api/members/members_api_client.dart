import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/members/create/member_create.dart';
import 'package:bloco_na_rua/data/services/api/members/imembers_api_client.dart';
import 'package:bloco_na_rua/domain/entities/members_entity.dart';
import 'package:result_dart/result_dart.dart';

class MembersApiClient implements IMembersApiClient {
  final IBaseApiClient baseApiClient;
  late final String _basePath;

  MembersApiClient(this.baseApiClient) {
    _basePath = '${baseApiClient.basePath}members';
  }

  @override
  IBaseApiClient get client => baseApiClient;

  @override
  AsyncResult<MembersEntity> createAsync(MemberCreate model) async {
    try {
      final body = model.toJson();
      final request = await baseApiClient.client.post(_basePath, data: body);
      if (request.statusCode != 201) {
        return Failure(
          Exception(
            'Request failed: ${request.statusCode} - ${request.statusMessage}',
          ),
        );
      }
      final response = await request.data;
      final result = MembersEntity.fromJson(response as Map<String, dynamic>);
      return Success(result);
    } catch (error) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $error'));
    }
  }
}
