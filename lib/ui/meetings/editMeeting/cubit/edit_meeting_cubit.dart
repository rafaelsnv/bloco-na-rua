import 'package:bloco_na_rua/core/api_error.dart';
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

  String _extractUserMessage(Object? error) {
    if (error == null) return 'Erro desconhecido';
    if (error is ApiError) return error.userMessage;
    if (error is Exception) {
      final msg = error.toString();
      if (msg.startsWith('Exception: ')) return msg.substring(11);
      return msg;
    }
    return error.toString();
  }

  Future<void> loadMeeting(int meetingId) async {
    emit(state.copyWith(status: EditMeetingStatus.loading));

    final result = await _meetingsRepository.getByIdAsync(meetingId);

    result.fold(
      (meeting) => emit(
        state.copyWith(status: EditMeetingStatus.loaded, meeting: meeting),
      ),
      (exception) {
        _log.warning('Load meeting failed', exception);
        emit(
          state.copyWith(
            status: EditMeetingStatus.failure,
            errorMessage: _extractUserMessage(exception),
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
        _log.warning('Update meeting failed', exception);
        emit(
          state.copyWith(
            status: EditMeetingStatus.failure,
            errorMessage: _extractUserMessage(exception),
          ),
        );
      },
    );
  }
}
