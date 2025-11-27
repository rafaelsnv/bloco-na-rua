import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/meetings/imeetings_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
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
  AsyncResult<List<MeetingsEntity>> getAllByBlockId(int blockId) async {
    try {
      final response = await baseApiClient.client.get(
        '$_basePath/block/$blockId',
      );
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = await response.data as List;
      final result = data.map((e) => MeetingsEntity.fromJson(e)).toList();
      return Success(result);
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }
}
