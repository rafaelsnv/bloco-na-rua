import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:equatable/equatable.dart';

sealed class MeetingDetailsState extends Equatable {
  const MeetingDetailsState();

  @override
  List<Object?> get props => [];
}

class MeetingDetailsInitial extends MeetingDetailsState {
  const MeetingDetailsInitial();
}

class MeetingDetailsLoading extends MeetingDetailsState {
  const MeetingDetailsLoading();
}

class MeetingDetailsLoaded extends MeetingDetailsState {
  final MeetingsEntity meeting;
  final List<MeetingPresencesEntity> presences;
  final PresencesStatus presencesStatus;
  final String? presencesError;
  final MarkingPresenceStatus markingPresenceStatus;
  final String? markingPresenceError;
  final DeleteStatus deleteStatus;
  final bool canDeleteMeeting;

  const MeetingDetailsLoaded({
    required this.meeting,
    this.presences = const [],
    this.presencesStatus = PresencesStatus.initial,
    this.presencesError,
    this.markingPresenceStatus = MarkingPresenceStatus.initial,
    this.markingPresenceError,
    this.deleteStatus = DeleteStatus.initial,
    this.canDeleteMeeting = false,
  });

  MeetingDetailsLoaded copyWith({
    MeetingsEntity? meeting,
    List<MeetingPresencesEntity>? presences,
    PresencesStatus? presencesStatus,
    String? presencesError,
    MarkingPresenceStatus? markingPresenceStatus,
    String? markingPresenceError,
    DeleteStatus? deleteStatus,
    bool? canDeleteMeeting,
  }) {
    return MeetingDetailsLoaded(
      meeting: meeting ?? this.meeting,
      presences: presences ?? this.presences,
      presencesStatus: presencesStatus ?? this.presencesStatus,
      presencesError: presencesError ?? this.presencesError,
      markingPresenceStatus:
          markingPresenceStatus ?? this.markingPresenceStatus,
      markingPresenceError: markingPresenceError ?? this.markingPresenceError,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      canDeleteMeeting: canDeleteMeeting ?? this.canDeleteMeeting,
    );
  }

  @override
  List<Object?> get props => [
    meeting,
    presences,
    presencesStatus,
    presencesError,
    markingPresenceStatus,
    markingPresenceError,
    deleteStatus,
    canDeleteMeeting,
  ];
}

class MeetingDetailsError extends MeetingDetailsState {
  final String message;

  const MeetingDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

enum PresencesStatus { initial, loading, loaded, error }

enum MarkingPresenceStatus { initial, loading, success, error }

enum DeleteStatus { initial, deleting, success, failure }
