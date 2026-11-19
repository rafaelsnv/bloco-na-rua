import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/ui/meetings/meeting_error.dart';
import 'package:equatable/equatable.dart';

enum UserMeetingsStatus { initial, loading, success, failure }

class UserMeetingsState extends Equatable {
  const UserMeetingsState({
    this.status = UserMeetingsStatus.initial,
    this.meetings = const [],
    this.error,
  });

  final UserMeetingsStatus status;
  final List<MeetingsEntity> meetings;

  /// The failure, when the operation failed. Localized by the screen.
  final MeetingError? error;

  UserMeetingsState copyWith({
    UserMeetingsStatus? status,
    List<MeetingsEntity>? meetings,
    MeetingError? error,
  }) {
    return UserMeetingsState(
      status: status ?? this.status,
      meetings: meetings ?? this.meetings,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, meetings, error];
}
