enum CreateMeetingStatus { initial, loading, success, failure }

class CreateMeetingState {
  final CreateMeetingStatus status;
  final String? errorMessage;

  const CreateMeetingState({
    this.status = CreateMeetingStatus.initial,
    this.errorMessage,
  });

  CreateMeetingState copyWith({
    CreateMeetingStatus? status,
    String? errorMessage,
  }) {
    return CreateMeetingState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
