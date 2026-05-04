import 'package:bloco_na_rua/core/irepository_base.dart';
import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IMeetingPresencesRepository
    implements IRepositoryBase<MeetingPresencesEntity> {
  AsyncResult<List<MeetingPresencesEntity>> getByMeetingId(int meetingId);
}
