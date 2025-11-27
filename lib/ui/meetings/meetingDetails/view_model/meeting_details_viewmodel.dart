import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class MeetingDetailsViewModel extends ChangeNotifier {
  MeetingDetailsViewModel({
    required IMeetingsRepository meetingsRepository,
    required this.meetingId,
  }) : _meetingsRepository = meetingsRepository {
    loadMeeting = Command.createAsyncNoParam(
      _loadMeetings,
      initialValue: Failure(Exception('Not executed')),
    )..execute();
  }

  final IMeetingsRepository _meetingsRepository;
  final String meetingId;
  final _log = Logger('MeetingDetailsViewModel');

  late Command<void, Result<MeetingsEntity>> loadMeeting;

  AsyncResult<MeetingsEntity> _loadMeetings() async {
    final result = await _meetingsRepository.getByIdAsync(int.parse(meetingId));

    if (result.isError()) {
      _log.warning('Load meeting failed', result.exceptionOrNull());
      return result;
    }
    return result;
  }
}
