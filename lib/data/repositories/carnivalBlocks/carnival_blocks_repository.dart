import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlocks/icarnival_blocks_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:result_dart/result_dart.dart';

class CarnivalBlocksRepository implements ICarnivalBlocksRepository {
  CarnivalBlocksRepository({required this.carnivalBlockApiClient});

  final ICarnivalBlocksApiClient carnivalBlockApiClient;

  @override
  AsyncResult<List<CarnivalBlocksEntity>> getAllAsync() async {
    return await carnivalBlockApiClient.getAllAsync();
  }

  @override
  AsyncResult<CarnivalBlocksEntity> getByIdAsync(int id) async {
    return await carnivalBlockApiClient.getByIdAsync(id);
  }

  @override
  AsyncResult deleteByIdAsync(int id) async {
    return await carnivalBlockApiClient.deleteAsync(id);
  }

  @override
  AsyncResult<CarnivalBlocksEntity> createAsync(
    Map<String, dynamic> data,
  ) async {
    return await carnivalBlockApiClient.createAsync<CarnivalBlocksEntity>(
      data,
      CarnivalBlocksEntity.fromJson,
    );
  }

  @override
  AsyncResult<CarnivalBlocksEntity> updateAsync(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await carnivalBlockApiClient.updateAsync(id, data);
  }

  @override
  AsyncResult<CarnivalBlocksEntity> getByInviteCodeAsync(
    String inviteCode,
  ) async {
    return await carnivalBlockApiClient.getByInviteCodeAsync(inviteCode);
  }
}
