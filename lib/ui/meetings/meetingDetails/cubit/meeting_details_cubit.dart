import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetingPresences/imeeting_presences_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class MeetingDetailsCubit extends Cubit<MeetingDetailsState> {
  MeetingDetailsCubit({
    required IMeetingsRepository meetingsRepository,
    required IMeetingPresencesRepository meetingPresencesRepository,
    required IAuthRepository authRepository,
    required this.meetingId,
  }) : _meetingsRepository = meetingsRepository,
       _meetingPresencesRepository = meetingPresencesRepository,
       _authRepository = authRepository,
       super(const MeetingDetailsInitial());

  final IMeetingsRepository _meetingsRepository;
  final IMeetingPresencesRepository _meetingPresencesRepository;
  final IAuthRepository _authRepository;
  final String meetingId;
  final _log = Logger('MeetingDetailsCubit');

  Future<void> loadMeeting() async {
    emit(const MeetingDetailsLoading());

    final result = await _meetingsRepository.getByIdAsync(int.parse(meetingId));

    result.fold((meeting) => emit(MeetingDetailsLoaded(meeting: meeting)), (
      exception,
    ) {
      final message = exception.toString().replaceAll("Exception: ", "");
      _log.warning('Load meeting failed', exception);
      emit(MeetingDetailsError(message));
    });
  }

  Future<void> loadPresences() async {
    final currentState = state;
    if (currentState is! MeetingDetailsLoaded) return;

    emit(currentState.copyWith(presencesStatus: PresencesStatus.loading));

    final result = await _meetingPresencesRepository.getByMeetingId(
      int.parse(meetingId),
    );

    result.fold(
      (presences) => emit(
        currentState.copyWith(
          presences: presences,
          presencesStatus: PresencesStatus.loaded,
        ),
      ),
      (exception) {
        _log.warning('Load presences failed', exception);
        emit(
          currentState.copyWith(
            presencesStatus: PresencesStatus.error,
            presencesError: exception.toString(),
          ),
        );
      },
    );
  }

  Future<void> markPresence({required bool isPresent}) async {
    final currentState = state;
    if (currentState is! MeetingDetailsLoaded) return;

    emit(
      currentState.copyWith(
        markingPresenceStatus: MarkingPresenceStatus.loading,
      ),
    );

    try {
      final uuid = await _authRepository.currentUuid;
      if (uuid == null || uuid.isEmpty) {
        emit(
          currentState.copyWith(
            markingPresenceStatus: MarkingPresenceStatus.error,
            markingPresenceError: 'Usuário não autenticado',
          ),
        );
        return;
      }

      final data = {
        'meetingId': int.parse(meetingId),
        'memberId':
            0, // Will be resolved by the API from X-Logged-Member header
        'isPresent': isPresent,
      };

      final result = await _meetingPresencesRepository.createAsync(data);

      result.fold(
        (presence) {
          emit(
            currentState.copyWith(
              markingPresenceStatus: MarkingPresenceStatus.success,
            ),
          );
          loadPresences(); // Reload presences list
        },
        (exception) {
          _log.warning('Mark presence failed', exception);
          emit(
            currentState.copyWith(
              markingPresenceStatus: MarkingPresenceStatus.error,
              markingPresenceError: exception.toString(),
            ),
          );
        },
      );
    } catch (e) {
      _log.severe('Mark presence unexpected error', e);
      emit(
        currentState.copyWith(
          markingPresenceStatus: MarkingPresenceStatus.error,
          markingPresenceError: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteMeeting() async {
    final currentState = state;
    if (currentState is! MeetingDetailsLoaded) return;

    emit(currentState.copyWith(deleteStatus: DeleteStatus.deleting));

    final result = await _meetingsRepository.delete(int.parse(meetingId));

    result.fold(
      (success) =>
          emit(currentState.copyWith(deleteStatus: DeleteStatus.success)),
      (exception) {
        _log.warning('Delete meeting failed', exception);
        emit(currentState.copyWith(deleteStatus: DeleteStatus.failure));
      },
    );
  }
}
