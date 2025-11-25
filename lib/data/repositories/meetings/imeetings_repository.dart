import 'package:bloco_na_rua/core/irepository_base.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meeting_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IMeetingsRepository
    implements IRepositoryBase<MeetingEntity> {
  AsyncResult<List<MeetingEntity>> getAllByBlockId(int id);
}
