import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:equatable/equatable.dart';

enum UserMeetingsStatus { initial, loading, success, failure }

class UserMeetingsState extends Equatable {
  const UserMeetingsState({
    this.status = UserMeetingsStatus.initial,
    this.meetings = const [],
    this.errorMessage,
  });

  final UserMeetingsStatus status;
  final List<MeetingsEntity> meetings;
  final String? errorMessage;

  UserMeetingsState copyWith({
    UserMeetingsStatus? status,
    List<MeetingsEntity>? meetings,
    String? errorMessage,
  }) {
    return UserMeetingsState(
      status: status ?? this.status,
      meetings: meetings ?? this.meetings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, meetings, errorMessage];
}
