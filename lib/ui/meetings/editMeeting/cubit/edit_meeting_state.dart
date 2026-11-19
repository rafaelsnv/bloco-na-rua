import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/ui/meetings/meeting_error.dart';
import 'package:equatable/equatable.dart';

enum EditMeetingStatus { initial, loading, loaded, saving, success, failure }

class EditMeetingState extends Equatable {
  final EditMeetingStatus status;
  final MeetingsEntity? meeting;

  /// The failure, when the operation failed. Localized by the screen.
  final MeetingError? error;

  const EditMeetingState({
    this.status = EditMeetingStatus.initial,
    this.meeting,
    this.error,
  });

  EditMeetingState copyWith({
    EditMeetingStatus? status,
    MeetingsEntity? meeting,
    MeetingError? error,
  }) {
    return EditMeetingState(
      status: status ?? this.status,
      meeting: meeting ?? this.meeting,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, meeting, error];
}
