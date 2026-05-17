import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_presences_cubit.freezed.dart';
part 'meeting_presences_state.dart';

class MeetingPresencesCubit extends Cubit<MeetingPresencesState> {
  MeetingPresencesCubit() : super(const MeetingPresencesState.initial());

  // TO-DO: Implement methods for MeetingPresencesCubit
}
