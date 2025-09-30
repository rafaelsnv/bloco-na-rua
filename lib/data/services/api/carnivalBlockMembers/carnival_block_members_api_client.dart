import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlockMembers/icarnival_block_members_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
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
  AsyncResult<List<CarnivalBlockMembersEntity>> getByMemberIdAsync(
    int id,
  ) async {
    try {
      final response = await baseApiClient.client.get('$_basePath/member/$id');
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      var jsonData = response.data as List<dynamic>;
      final data = jsonData
          .map((e) => CarnivalBlockMembersEntity.fromJson(e))
          .toList();
      return Success(data);
    } catch (error) {
      return Failure(Exception('An error occurred: $error'));
    }
  }
}
