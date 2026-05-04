import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract class IMeetingsApiClient {
  IBaseApiClient get client;

  AsyncResult<List<MeetingsEntity>> getAllByBlockId(int blockId);

  AsyncResult<MeetingsEntity> createAsync(Map<String, dynamic> data);

  AsyncResult<MeetingsEntity> updateAsync(int id, Map<String, dynamic> data);

  AsyncResult deleteAsync(int id);

  AsyncResult<List<MeetingsEntity>> getAllAsync();
}
