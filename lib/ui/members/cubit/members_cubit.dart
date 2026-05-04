import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/ui/members/cubit/members_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersCubit extends Cubit<MembersState> {
  MembersCubit({required IMembersRepository membersRepository})
      : _membersRepository = membersRepository,
        super(const MembersState());

  final IMembersRepository _membersRepository;

  String _extractUserMessage(Object? error) {
    if (error == null) return 'Erro desconhecido';
    if (error is ApiError) return error.userMessage;
    if (error is Exception) {
      final msg = error.toString();
      if (msg.startsWith('Exception: ')) return msg.substring(11);
      return msg;
    }
    return error.toString();
  }

  Future<void> loadMembers() async {
    emit(state.copyWith(status: MembersStatus.loading));

    final result = await _membersRepository.getAllAsync();

    result.fold(
      (members) =>
          emit(state.copyWith(status: MembersStatus.success, members: members)),
      (error) => emit(
        state.copyWith(
          status: MembersStatus.error,
          errorMessage: _extractUserMessage(error),
        ),
      ),
    );
  }
}
