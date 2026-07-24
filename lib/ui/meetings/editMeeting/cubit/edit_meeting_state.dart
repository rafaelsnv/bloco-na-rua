import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:equatable/equatable.dart';

enum EditMeetingStatus { initial, loading, loaded, saving, success, failure }

class EditMeetingState extends Equatable {
  final EditMeetingStatus status;
  final MeetingsEntity? meeting;
  final String? errorMessage;

  const EditMeetingState({
    this.status = EditMeetingStatus.initial,
    this.meeting,
    this.errorMessage,
  });

  EditMeetingState copyWith({
    EditMeetingStatus? status,
    MeetingsEntity? meeting,
    String? errorMessage,
  }) {
    return EditMeetingState(
      status: status ?? this.status,
      meeting: meeting ?? this.meeting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, meeting, errorMessage];
}
