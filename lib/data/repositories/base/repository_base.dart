import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:bloco_na_rua/core/irepository_base.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:result_dart/result_dart.dart';

class RepositoryBase<TEntity extends EntityBase>
    implements IRepositoryBase<TEntity> {
  RepositoryBase({
    required IBaseApiClient client,
    required JsonFactory<TEntity> fromJsonFactory,
  }) : apiClient = client,
       _fromJsonFactory = fromJsonFactory;

  final IBaseApiClient apiClient;
  final JsonFactory<TEntity> _fromJsonFactory;

  @override
  AsyncResult<List<TEntity>> getAllAsync() async {
    return await apiClient.getAllAsync<TEntity>(_fromJsonFactory);
  }

  @override
  AsyncResult<TEntity> getByIdAsync(int id) async {
    return await apiClient.getByIdAsync<TEntity>(id, _fromJsonFactory);
  }

  @override
  AsyncResult deleteByIdAsync(int id) async {
    return await apiClient.deleteByIdAsync<TEntity>(id);
  }

  @override
  AsyncResult<TEntity> createAsync(Map<String, dynamic> data) async {
    return await apiClient.createAsync<TEntity>(data, _fromJsonFactory);
  }
}
