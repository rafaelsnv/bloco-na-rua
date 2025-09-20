import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:bloco_na_rua/core/irepository_base.dart';
import 'package:bloco_na_rua/data/services/api/api_client.dart';
import 'package:result_dart/result_dart.dart';

class RepositoryBase<TEntity extends EntityBase>
    implements IRepositoryBase<TEntity> {
  RepositoryBase({
    required ApiClient apiClient,
    required JsonFactory<TEntity> fromJsonFactory,
  }) : _apiClient = apiClient,
       _fromJsonFactory = fromJsonFactory;

  final ApiClient _apiClient;
  final JsonFactory<TEntity> _fromJsonFactory;

  @override
  AsyncResult<List<TEntity>> getAllAsync() async {
    return await _apiClient.getAllAsync<TEntity>(_fromJsonFactory);
  }

  @override
  AsyncResult<TEntity> getByIdAsync(int id) async {
    return await _apiClient.getByIdAsync<TEntity>(id, _fromJsonFactory);
  }

  @override
  AsyncResult deleteByIdAsync(int id) async {
    return await _apiClient.deleteByIdAsync<TEntity>(id, _fromJsonFactory);
  }
}
