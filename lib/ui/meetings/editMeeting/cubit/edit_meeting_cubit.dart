import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class EditMeetingCubit extends Cubit<EditMeetingState> {
  EditMeetingCubit({required IMeetingsRepository meetingsRepository})
    : _meetingsRepository = meetingsRepository,
      super(const EditMeetingState());

  final IMeetingsRepository _meetingsRepository;
  final _log = Logger('EditMeetingCubit');

  Future<void> loadMeeting(int meetingId) async {
    emit(state.copyWith(status: EditMeetingStatus.loading));

    final result = await _meetingsRepository.getByIdAsync(meetingId);

    result.fold(
      (meeting) => emit(
        state.copyWith(status: EditMeetingStatus.loaded, meeting: meeting),
      ),
      (exception) {
        final message = exception.toString().replaceAll('Exception: ', '');
        _log.warning('Load meeting failed', exception);
        emit(
          state.copyWith(
            status: EditMeetingStatus.failure,
            errorMessage: message,
          ),
        );
      },
    );
  }

  Future<void> updateMeeting(int id, Map<String, dynamic> data) async {
    emit(state.copyWith(status: EditMeetingStatus.saving));

    final result = await _meetingsRepository.update(id, data);

    result.fold(
      (meeting) => emit(
        state.copyWith(status: EditMeetingStatus.success, meeting: meeting),
      ),
      (exception) {
        final message = exception.toString().replaceAll('Exception: ', '');
        _log.warning('Update meeting failed', exception);
        emit(
          state.copyWith(
            status: EditMeetingStatus.failure,
            errorMessage: message,
          ),
        );
      },
    );
  }
}
