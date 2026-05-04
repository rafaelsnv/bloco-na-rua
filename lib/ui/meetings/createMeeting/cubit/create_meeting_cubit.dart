import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/ui/meetings/createMeeting/cubit/create_meeting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class CreateMeetingCubit extends Cubit<CreateMeetingState> {
  CreateMeetingCubit({required IMeetingsRepository meetingsRepository})
      : _meetingsRepository = meetingsRepository,
        super(const CreateMeetingState());

  final IMeetingsRepository _meetingsRepository;
  final _log = Logger('CreateMeetingCubit');

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

  Future<void> createMeeting(Map<String, dynamic> data) async {
    emit(state.copyWith(status: CreateMeetingStatus.loading));

    final result = await _meetingsRepository.create(data);

    result.fold(
      (_) => emit(state.copyWith(status: CreateMeetingStatus.success)),
      (exception) {
        _log.warning('Create meeting failed', exception);
        emit(
          state.copyWith(
            status: CreateMeetingStatus.failure,
            errorMessage: _extractUserMessage(exception),
          ),
        );
      },
    );
  }
}
