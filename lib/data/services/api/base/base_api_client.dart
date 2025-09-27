import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

class BaseApiClient implements IBaseApiClient {
  BaseApiClient({this.options, this.clientFactory}) {
    client = (clientFactory ?? Dio.new)(options);
  }

  @override
  final Dio Function(BaseOptions?)? clientFactory;
  @override
  final BaseOptions? options;
  @override
  late final Dio client;
  @override
  final String basePath = '/api/v1/';

  @override
  AsyncResult<List<TEntity>> getAllAsync<TEntity extends EntityBase>(
    JsonFactory<TEntity> fromJsonFactory,
  ) async {
    try {
      String endpoint = TEntity.toString()
          .replaceAll('Entity', '')
          .toLowerCase();
      // final request = await client.get('/api/v1/$endpoint');
      final response = await client.get('$basePath$endpoint');
      if (response.statusCode != 200) {
        return Failure(formatError(response));
      }

      final data = await response.data as List<dynamic>;

      return Success(
        data
            .map((element) => fromJsonFactory(element as Map<String, dynamic>))
            .toList(),
      );
    } catch (error) {
      client.close();
      return Failure(Exception('An error occurred: $error'));
    }
  }

  @override
  AsyncResult<TEntity> getByIdAsync<TEntity extends EntityBase>(
    int id,
    JsonFactory<TEntity> fromJsonFactory,
  ) async {
    try {
      String endpoint = TEntity.toString().replaceAll('Entity', '');
      final response = await client.get('$basePath$endpoint/${id.toString()}');
      if (response.statusCode != 200) {
        return Failure(formatError(response));
      }

      final data = await response.data;
      return Success(fromJsonFactory(data as Map<String, dynamic>));
    } catch (error) {
      client.close();
      return Failure(Exception('An error occurred: $error'));
    }
  }

  @override
  AsyncResult deleteByIdAsync<TEntity extends EntityBase>(int id) async {
    try {
      String endpoint = TEntity.toString().replaceAll('Entity', '');
      final response = await client.delete(
        '$basePath$endpoint/${id.toString()}',
      );
      if (response.statusCode != 204) {
        return Failure(formatError(response));
      }
      return Success(response.statusCode.toString());
    } catch (error) {
      client.close();
      return Failure(Exception('An error occurred: $error'));
    }
  }

  @override
  Exception formatError(Response response) {
    return Exception(
      'Request failed: ${response.statusCode} - ${response.statusMessage}',
    );
  }
}
