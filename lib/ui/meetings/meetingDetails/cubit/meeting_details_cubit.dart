import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetingPresences/imeeting_presences_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
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
    required ICarnivalBlockMembersRepository carnivalBlockMembersRepository,
    required IMembersRepository membersRepository,
    required GetCurrentUserData getCurrentUserData,
    required this.meetingId,
  }) : _meetingsRepository = meetingsRepository,
       _meetingPresencesRepository = meetingPresencesRepository,
       _authRepository = authRepository,
       _carnivalBlocksRepository = carnivalBlocksRepository,
       _carnivalBlockMembersRepository = carnivalBlockMembersRepository,
       _membersRepository = membersRepository,
       _getCurrentUserData = getCurrentUserData,
       super(const MeetingDetailsInitial());

  final IMeetingsRepository _meetingsRepository;
  final IMeetingPresencesRepository _meetingPresencesRepository;
  final IAuthRepository _authRepository;
  final ICarnivalBlocksRepository _carnivalBlocksRepository;
  final ICarnivalBlockMembersRepository _carnivalBlockMembersRepository;
  final IMembersRepository _membersRepository;
  final GetCurrentUserData _getCurrentUserData;
  final String meetingId;
  final _log = Logger('MeetingDetailsCubit');
  bool _isMarkingPresence = false;
  // ponytail: in-flight presence ops by memberId-meetingId composite key.
  // Guards against rapid taps / concurrent calls that bypass markPresence.
  final Set<String> _inFlightPresenceKeys = {};

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
        // Fetch the block once: name for display + owner check for delete.
        final uuid = await _authRepository.currentUuid;
        bool canDelete = false;
        String? blockName;

        if (meeting.carnivalBlockId != null) {
          final blockResult = await _carnivalBlocksRepository.getByIdAsync(
            meeting.carnivalBlockId!,
          );
          blockResult.fold((block) {
            blockName = block.name;
            canDelete = uuid != null && block.ownerId.toString() == uuid;
          }, (_) {});
        }

        emit(
          MeetingDetailsLoaded(
            meeting: meeting,
            canDeleteMeeting: canDelete,
            blockName: blockName,
          ),
        );
        // Chained (not screen-level parallel) so `MeetingDetailsLoaded` is
        // emitted before `loadPresences`'s early-return guard fires.
        await loadPresences();
        await _loadBlockMembers(meeting.carnivalBlockId);
      },
      (exception) {
        _log.warning('Load meeting failed', exception);
        emit(MeetingDetailsError(extractUserMessage(exception)));
      },
    );
  }

  /// Loads the block's member roster (with member entities for names) and
  /// computes whether the current user can manage presences (owner or
  /// admin/moderator role).
  Future<void> _loadBlockMembers(int? carnivalBlockId) async {
    final currentState = state;
    if (currentState is! MeetingDetailsLoaded || carnivalBlockId == null) return;

    final membersResult = await _carnivalBlockMembersRepository
        .getByBlockIdAsync(carnivalBlockId);

    final blockMembers = membersResult.getOrNull() ?? [];
    if (blockMembers.isEmpty) {
      emit(currentState.copyWith(blockMembers: const []));
      return;
    }

    // Single batch fetch: GET /Members?ids=1,2,3 (backend-supported).
    final ids = blockMembers.map((m) => m.memberId).toList();
    final entitiesResult = await _membersRepository.getByIdsAsync(ids);
    final fetched = entitiesResult.getOrNull() ?? [];
    final byId = {for (final e in fetched) e.id: e};
    final memberEntities = <int, MembersEntity>{
      for (final member in blockMembers)
        member.memberId: byId[member.memberId] ??
            // Member row exists but entity missing (deleted?) — placeholder.
            MembersEntity(id: member.memberId, name: "Membro"),
    };

    // Owner or admin/moderator (role 1/2) can manage presences.
    final currentMember = await _resolveCurrentMember();
    final currentMemberId = currentMember?.id;
    final myMembership = blockMembers
        .where((m) => m.memberId == currentMemberId)
        .firstOrNull;

    // Owner check: block ownerId vs current member id.
    bool isOwner = false;
    if (currentMemberId != null) {
      final blockResult = await _carnivalBlocksRepository.getByIdAsync(
        carnivalBlockId,
      );
      isOwner = blockResult.fold(
        (block) => block.ownerId == currentMemberId,
        (_) => false,
      );
    }
    final hasManagerRole =
        myMembership != null && (myMembership.role == 1 || myMembership.role == 2);

    emit(
      currentState.copyWith(
        blockMembers: blockMembers,
        memberEntities: memberEntities,
        canManagePresence: isOwner || hasManagerRole,
      ),
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
    final member = await _resolveCurrentMember();
    if (member == null) {
      final currentState = state;
      if (currentState is! MeetingDetailsLoaded) return;
      emit(
        currentState.copyWith(
          markingPresenceStatus: MarkingPresenceStatus.error,
          markingPresenceError: 'Usuário não autenticado',
        ),
      );
      return;
    }
    // ponytail: guard by composite key to deduplicate rapid taps.
    final key = '${member.id}_$meetingId';
    if (_inFlightPresenceKeys.contains(key)) return;
    await setMemberPresence(memberId: member.id, isPresent: isPresent);
  }

  /// Sets the presence of any block member (used by owners/managers and by
  /// the self-marking FABs).
  Future<void> setMemberPresence({
    required int memberId,
    required bool isPresent,
  }) async {
    final idempotencyKey = '${memberId}_$meetingId';
    if (_isMarkingPresence) return;
    if (!_inFlightPresenceKeys.add(idempotencyKey)) return; // already in flight
    _isMarkingPresence = true;

    final currentState = state;
    if (currentState is! MeetingDetailsLoaded) {
      _isMarkingPresence = false;
      _inFlightPresenceKeys.remove(idempotencyKey);
      return;
    }

    emit(
      currentState.copyWith(
        markingPresenceStatus: MarkingPresenceStatus.loading,
      ),
    );

    try {
      // Toggle: update the existing row if present, otherwise create a new
      // one (POST has no upsert server-side, so always POSTing duplicates).
      final existingRow = currentState.presences
          .where((row) => row.memberId == memberId)
          .firstOrNull;

      final ResultDart<MeetingPresencesEntity, Exception> result;
      if (existingRow != null) {
        result = await _meetingPresencesRepository.updateAsync(
          existingRow.id,
          {'isPresent': isPresent},
        );
      } else {
        // ponytail: idempotency key prevents duplicates on rapid calls
        result = await _meetingPresencesRepository.createAsync(
          {
            'meetingId': currentState.meeting.id,
            'memberId': memberId,
            'carnivalBlockId': currentState.meeting.carnivalBlockId,
            'isPresent': isPresent,
          },
          idempotencyKey: idempotencyKey,
        );
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
      _inFlightPresenceKeys.remove(idempotencyKey);
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
