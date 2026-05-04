import 'package:bloco_na_rua/core/irepository_base.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ICarnivalBlocksRepository
    implements IRepositoryBase<CarnivalBlocksEntity> {
  AsyncResult<CarnivalBlocksEntity> updateAsync(int id, Map<String, dynamic> data);
}
