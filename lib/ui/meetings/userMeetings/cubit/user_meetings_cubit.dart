import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/domain/use_cases/meetings/get_user_meetings_use_case.dart';
import 'package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class UserMeetingsCubit extends Cubit<UserMeetingsState> {
  UserMeetingsCubit({required GetUserMeetingsUseCase getUserMeetingsUseCase})
      : _getUserMeetingsUseCase = getUserMeetingsUseCase,
        super(const UserMeetingsState());

  final GetUserMeetingsUseCase _getUserMeetingsUseCase;
  final _log = Logger('UserMeetingsCubit');

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

  Future<void> loadMeetings() async {
    emit(state.copyWith(status: UserMeetingsStatus.loading));

    try {
      final result = await _getUserMeetingsUseCase();

      if (result.isError()) {
        final error = result.exceptionOrNull();
        _log.warning('Failed to load user meetings', error);
        emit(
          state.copyWith(
            status: UserMeetingsStatus.failure,
            errorMessage: _extractUserMessage(error),
          ),
        );
        return;
      }

      final meetings = result.getOrNull() ?? [];

      emit(
        state.copyWith(status: UserMeetingsStatus.success, meetings: meetings),
      );
    } catch (e) {
      _log.severe('Unexpected error during loadMeetings', e);
      emit(
        state.copyWith(
          status: UserMeetingsStatus.failure,
          errorMessage: _extractUserMessage(e),
        ),
      );
    }
  }
}
