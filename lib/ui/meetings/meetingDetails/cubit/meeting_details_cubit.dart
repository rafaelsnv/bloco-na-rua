import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetingPresences/imeeting_presences_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:result_dart/result_dart.dart';
import 'package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class MeetingDetailsCubit extends Cubit<MeetingDetailsState> {
  MeetingDetailsCubit({
    required IMeetingsRepository meetingsRepository,
    required IMeetingPresencesRepository meetingPresencesRepository,
    required IAuthRepository authRepository,
    required ICarnivalBlocksRepository carnivalBlocksRepository,
    required GetCurrentUserData getCurrentUserData,
    required this.meetingId,
  }) : _meetingsRepository = meetingsRepository,
       _meetingPresencesRepository = meetingPresencesRepository,
       _authRepository = authRepository,
       _carnivalBlocksRepository = carnivalBlocksRepository,
       _getCurrentUserData = getCurrentUserData,
       super(const MeetingDetailsInitial());

  final IMeetingsRepository _meetingsRepository;
  final IMeetingPresencesRepository _meetingPresencesRepository;
  final IAuthRepository _authRepository;
  final ICarnivalBlocksRepository _carnivalBlocksRepository;
  final GetCurrentUserData _getCurrentUserData;
  final String meetingId;
  final _log = Logger('MeetingDetailsCubit');
  bool _isMarkingPresence = false;

  Future<void> loadMeeting() async {
    emit(const MeetingDetailsLoading());

    final meetingIdInt = int.tryParse(meetingId);
    if (meetingIdInt == null) {
      emit(const MeetingDetailsError('ID da reunião inválido'));
      return;
    }

    final result = await _meetingsRepository.getByIdAsync(meetingIdInt);

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
        // Chained (not screen-level parallel) so `MeetingDetailsLoaded` is
        // emitted before `loadPresences`'s early-return guard fires.
        await loadPresences();
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

    final meetingIdInt = int.tryParse(meetingId);
    if (meetingIdInt == null) {
      emit(
        currentState.copyWith(
          presences: [],
          presencesStatus: PresencesStatus.error,
          presencesError: 'ID da reunião inválido',
        ),
      );
      return;
    }

    emit(currentState.copyWith(presencesStatus: PresencesStatus.loading));

    final result = await _meetingPresencesRepository.getByMeetingId(
      meetingIdInt,
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

  /// Returns the cached current member, resolving (and caching) it via
  /// GetCurrentUserData when not yet populated.
  Future<MembersEntity?> _resolveCurrentMember() async {
    final cached = _authRepository.currentMember;
    if (cached != null) return cached;

    final result = await _getCurrentUserData();
    return result.fold(
      (member) => member,
      (exception) {
        _log.warning('Resolve current member failed', exception);
        return null;
      },
    );
  }

  Future<void> markPresence({required bool isPresent}) async {
    if (_isMarkingPresence) return;
    _isMarkingPresence = true;

    final currentState = state;
    if (currentState is! MeetingDetailsLoaded) {
      _isMarkingPresence = false;
      return;
    }

    emit(
      currentState.copyWith(
        markingPresenceStatus: MarkingPresenceStatus.loading,
      ),
    );

    try {
      final member = await _resolveCurrentMember();
      if (member == null) {
        emit(
          currentState.copyWith(
            markingPresenceStatus: MarkingPresenceStatus.error,
            markingPresenceError: 'Usuário não autenticado',
          ),
        );
        return;
      }

      // Toggle: update the existing row if present, otherwise create a new
      // one (POST has no upsert server-side, so always POSTing duplicates).
      final existingRow = currentState.presences
          .where((row) => row.memberId == member.id)
          .firstOrNull;

      final ResultDart<MeetingPresencesEntity, Exception> result;
      if (existingRow != null) {
        result = await _meetingPresencesRepository.updateAsync(
          existingRow.id,
          {'isPresent': isPresent},
        );
      } else {
        result = await _meetingPresencesRepository.createAsync({
          'meetingId': currentState.meeting.id,
          'carnivalBlockId': currentState.meeting.carnivalBlockId,
          'isPresent': isPresent,
        });
      }

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
    } finally {
      _isMarkingPresence = false;
    }
  }

  Future<void> deleteMeeting() async {
    final currentState = state;
    if (currentState is! MeetingDetailsLoaded) return;

    emit(currentState.copyWith(deleteStatus: DeleteStatus.deleting));

    final result = await _meetingsRepository.delete(currentState.meeting.id);

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
