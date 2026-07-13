import 'package:bloco_na_rua/core/errors/user_message.dart';
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
            errorMessage: extractUserMessage(error),
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
          errorMessage: extractUserMessage(e),
        ),
      );
    }
  }
}
