import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/ui/members/cubit/members_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersCubit extends Cubit<MembersState> {
  MembersCubit({required IMembersRepository membersRepository})
    : _membersRepository = membersRepository,
      super(const MembersState());

  final IMembersRepository _membersRepository;

  // ponytail: TO-DO(M10): getAllAsync() returns ALL members in the system — privacy leak.
  // Backend must provide a block-scoped endpoint (e.g. GET /Members/by-block/{blockId})
  // or filter by authenticated user's accessible blocks. Do NOT merge until backend is ready.
  Future<void> loadMembers() async {
    emit(state.copyWith(status: MembersStatus.loading));

    final result = await _membersRepository.getAllAsync();

    result.fold(
      (members) =>
          emit(state.copyWith(status: MembersStatus.success, members: members)),
      (error) => emit(
        state.copyWith(
          status: MembersStatus.error,
          // ponytail: TO-DO: user-facing message should reference block-scoped access once backend is fixed
          errorMessage:
              'Membros devem ser carregados por bloco. '
              'Contate o suporte se o problema persistir.',
        ),
      ),
    );
  }
}
