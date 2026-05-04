import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlocks/icarnival_blocks_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:result_dart/result_dart.dart';

class CarnivalBlocksApiClient implements ICarnivalBlocksApiClient {
  final IBaseApiClient baseApiClient;
  late final String _basePath;

  CarnivalBlocksApiClient(this.baseApiClient) {
    _basePath = '${baseApiClient.basePath}CarnivalBlocks';
  }

  @override
  IBaseApiClient get client => baseApiClient;

  @override
  AsyncResult<CarnivalBlocksEntity> getByIdAsync(int id) async {
    try {
      final response = await baseApiClient.client.get('$_basePath/$id');
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = await response.data;
      final result = CarnivalBlocksEntity.fromJson(data as Map<String, dynamic>);
      return Success(result);
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }

  @override
  AsyncResult<List<CarnivalBlocksEntity>> getAllAsync() async {
    try {
      final response = await baseApiClient.client.get(_basePath);
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      final data = response.data as List;
      final result = data.map((e) => CarnivalBlocksEntity.fromJson(e)).toList();
      return Success(result);
    } catch (error) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $error'));
    }
  }

  @override
  AsyncResult deleteAsync(int id) async {
    try {
      final response = await baseApiClient.client.delete('$_basePath/$id');
      if (response.statusCode != 204) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(response.statusCode.toString());
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }

  @override
  AsyncResult<TEntity> createAsync<TEntity extends EntityBase>(
    Map<String, dynamic> data,
    JsonFactory<TEntity> fromJsonFactory,
  ) async {
    return await baseApiClient.createAsync(data, fromJsonFactory);
  }

  @override
  AsyncResult<CarnivalBlocksEntity> updateAsync(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await baseApiClient.client.put(
        '$_basePath/$id',
        data: data,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(CarnivalBlocksEntity.fromJson(response.data));
    } on Exception catch (e) {
      baseApiClient.client.close();
      return Failure(Exception('An error occurred: $e'));
    }
  }
}
