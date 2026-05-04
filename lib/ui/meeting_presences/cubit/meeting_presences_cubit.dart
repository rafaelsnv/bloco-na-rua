import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_presences_state.dart';
part 'meeting_presences_cubit.freezed.dart';

class MeetingPresencesCubit extends Cubit<MeetingPresencesState> {
  MeetingPresencesCubit() : super(const MeetingPresencesState.initial());

  // TODO: Implement methods for MeetingPresencesCubit
}
