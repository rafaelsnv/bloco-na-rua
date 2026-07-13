import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
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
    required ICarnivalBlocksRepository carnivalBlocksRepository,
    required this.meetingId,
  }) : _meetingsRepository = meetingsRepository,
       _meetingPresencesRepository = meetingPresencesRepository,
       _authRepository = authRepository,
       _carnivalBlocksRepository = carnivalBlocksRepository,
       super(const MeetingDetailsInitial());

  final IMeetingsRepository _meetingsRepository;
  final IMeetingPresencesRepository _meetingPresencesRepository;
  final IAuthRepository _authRepository;
  final ICarnivalBlocksRepository _carnivalBlocksRepository;
  final String meetingId;
  final _log = Logger('MeetingDetailsCubit');

  Future<void> loadMeeting() async {
    emit(const MeetingDetailsLoading());

    final result = await _meetingsRepository.getByIdAsync(int.parse(meetingId));

    result.fold(
      (meeting) async {
        // Check if current user can delete (is block owner)
        final uuid = await _authRepository.currentUuid;
        bool canDelete = false;

        if (uuid != null && meeting.carnivalBlockId != null) {
          final blockResult = await _carnivalBlocksRepository.getByIdAsync(
            meeting.carnivalBlockId!,
          );
          canDelete = blockResult.fold(
            (block) => block.ownerId.toString() == uuid,
            (_) => false,
          );
        }

        emit(
          MeetingDetailsLoaded(meeting: meeting, canDeleteMeeting: canDelete),
        );
      },
      (exception) {
        _log.warning('Load meeting failed', exception);
        emit(MeetingDetailsError(extractUserMessage(exception)));
      },
    );
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
        // Show empty list instead of error
        emit(
          currentState.copyWith(
            presences: [],
            presencesStatus: PresencesStatus.loaded,
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
              markingPresenceError: extractUserMessage(exception),
            ),
          );
        },
      );
    } catch (e) {
      _log.severe('Mark presence unexpected error', e);
      emit(
        currentState.copyWith(
          markingPresenceStatus: MarkingPresenceStatus.error,
          markingPresenceError: extractUserMessage(e),
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
