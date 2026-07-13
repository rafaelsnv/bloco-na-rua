import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/ui/members/cubit/members_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersCubit extends Cubit<MembersState> {
  MembersCubit({required IMembersRepository membersRepository})
    : _membersRepository = membersRepository,
      super(const MembersState());

  final IMembersRepository _membersRepository;

  Future<void> loadMembers() async {
    emit(state.copyWith(status: MembersStatus.loading));

    final result = await _membersRepository.getAllAsync();

    result.fold(
      (members) =>
          emit(state.copyWith(status: MembersStatus.success, members: members)),
      (error) => emit(
        state.copyWith(
          status: MembersStatus.error,
          errorMessage: extractUserMessage(error),
        ),
      ),
    );
  }
}
