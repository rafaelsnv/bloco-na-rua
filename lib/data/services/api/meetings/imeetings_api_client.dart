import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meeting_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract class IMeetingsApiClient {
  IBaseApiClient get client;

  AsyncResult<List<MeetingEntity>> getAllByBlockId(int blockId);
}
