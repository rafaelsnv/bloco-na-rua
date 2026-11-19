import 'package:bloco_na_rua/ui/meetings/meeting_error.dart';

enum CreateMeetingStatus { initial, loading, success, failure }

class CreateMeetingState {
  final CreateMeetingStatus status;

  /// The failure, when the operation failed. Localized by the screen.
  final MeetingError? error;

  const CreateMeetingState({
    this.status = CreateMeetingStatus.initial,
    this.error,
  });

  CreateMeetingState copyWith({
    CreateMeetingStatus? status,
    MeetingError? error,
  }) {
    return CreateMeetingState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
