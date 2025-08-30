import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:bloco_na_rua/core/irepository_base.dart';
import 'package:bloco_na_rua/data/services/api/api_client_dio.dart';
import 'package:result_dart/result_dart.dart';

class RepositoryBase<TEntity extends EntityBase>
    implements IRepositoryBase<TEntity> {
  RepositoryBase({
    required ApiClientDio apiClient,
    required JsonFactory<TEntity> fromJsonFactory,
  }) : _apiClient = apiClient,
       _fromJsonFactory = fromJsonFactory;

  final ApiClientDio _apiClient;
  final JsonFactory<TEntity> _fromJsonFactory;

  @override
  AsyncResult<List<TEntity>> getAllAsync() {
    return _apiClient.getAllAsync<TEntity>(_fromJsonFactory);
  }
}
