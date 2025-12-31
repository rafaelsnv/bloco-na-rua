import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class MeetingDetailsCubit extends Cubit<MeetingDetailsState> {
  MeetingDetailsCubit({
    required IMeetingsRepository meetingsRepository,
    required this.meetingId,
  })  : _meetingsRepository = meetingsRepository,
        super(const MeetingDetailsInitial());

  final IMeetingsRepository _meetingsRepository;
  final String meetingId;
  final _log = Logger('MeetingDetailsCubit');

  Future<void> loadMeeting() async {
    emit(const MeetingDetailsLoading());

    final result = await _meetingsRepository.getByIdAsync(int.parse(meetingId));

    result.fold(
      (meeting) => emit(MeetingDetailsLoaded(meeting)),
      (exception) {
        final message = exception.toString().replaceAll("Exception: ", "");
        _log.warning('Load meeting failed', exception);
        emit(MeetingDetailsError(message));
      },
    );
  }
}
