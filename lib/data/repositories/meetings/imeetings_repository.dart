import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IMeetingsRepository {
  AsyncResult<List<MeetingsEntity>> getAllAsync();

  AsyncResult<MeetingsEntity> getByIdAsync(int id);

  AsyncResult deleteByIdAsync(int id);

  AsyncResult<MeetingsEntity> createAsync(Map<String, dynamic> data);

  AsyncResult<List<MeetingsEntity>> getAllByBlockId(int id);

  AsyncResult<MeetingsEntity> create(Map<String, dynamic> data);

  AsyncResult<MeetingsEntity> update(int id, Map<String, dynamic> data);

  AsyncResult delete(int id);
}
