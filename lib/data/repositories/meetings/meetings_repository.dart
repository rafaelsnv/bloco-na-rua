import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/data/services/api/meetings/imeetings_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:result_dart/result_dart.dart';

class MeetingsRepository implements IMeetingsRepository {
  MeetingsRepository({required this.meetingsApiClient});

  final IMeetingsApiClient meetingsApiClient;

  @override
  AsyncResult<List<MeetingsEntity>> getAllAsync() async {
    return await meetingsApiClient.getAllAsync();
  }

  @override
  AsyncResult<MeetingsEntity> getByIdAsync(int id) async {
    return await meetingsApiClient.getByIdAsync(id);
  }

  @override
  AsyncResult deleteByIdAsync(int id) async {
    return await meetingsApiClient.deleteAsync(id);
  }

  @override
  AsyncResult<MeetingsEntity> createAsync(Map<String, dynamic> data) async {
    return await meetingsApiClient.createAsync(data);
  }

  @override
  AsyncResult<List<MeetingsEntity>> getAllByBlockId(int id) async {
    return await meetingsApiClient.getAllByBlockId(id);
  }

  @override
  AsyncResult<MeetingsEntity> create(Map<String, dynamic> data) async {
    return await meetingsApiClient.createAsync(data);
  }

  @override
  AsyncResult<MeetingsEntity> update(int id, Map<String, dynamic> data) async {
    return await meetingsApiClient.updateAsync(id, data);
  }

  @override
  AsyncResult delete(int id) async {
    return await meetingsApiClient.deleteAsync(id);
  }
}
