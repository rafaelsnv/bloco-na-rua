import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IRepositoryBase<TEntity extends EntityBase> {
  AsyncResult<List<TEntity>> getAllAsync();
}
