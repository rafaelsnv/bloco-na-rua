import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

abstract class IBaseApiClient {
  Dio get client;
  String get basePath;
  BaseOptions? get options;
  Dio Function(BaseOptions?)? get clientFactory;

  AsyncResult<List<TEntity>> getAllAsync<TEntity extends EntityBase>(
    JsonFactory<TEntity> fromJsonFactory,
  );

  AsyncResult<TEntity> getByIdAsync<TEntity extends EntityBase>(
    int id,
    JsonFactory<TEntity> fromJsonFactory,
  );

  AsyncResult deleteByIdAsync<TEntity extends EntityBase>(int id);
}