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

  const MeetingDetailsLoaded(this.meeting);

  @override
  List<Object?> get props => [meeting];
}

class MeetingDetailsError extends MeetingDetailsState {
  final String message;

  const MeetingDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
