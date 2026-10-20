import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinBlockCubit extends Cubit<JoinBlockState> {
  JoinBlockCubit({
    required ICarnivalBlockMembersRepository carnivalBlockMembersRepository,
  }) : _carnivalBlockMembersRepository = carnivalBlockMembersRepository,
       super(JoinBlockInitial());

  final ICarnivalBlockMembersRepository _carnivalBlockMembersRepository;
  bool _isLoading = false;

  Future<void> joinBlock(String inviteCode) async {
    if (_isLoading) return;
    _isLoading = true;

    if (inviteCode.isEmpty) {
      emit(const JoinBlockError('O código de convite não pode estar vazio.'));
      return;
    }

    emit(JoinBlockLoading());

    try {
      final joinResult = await _carnivalBlockMembersRepository.joinByInviteCodeAsync(
        inviteCode,
      );

      joinResult.fold(
        (_) => emit(JoinBlockSuccess()),
        (failure) => emit(
          JoinBlockError(
            'Erro ao entrar no bloco: ${extractUserMessage(failure)}',
          ),
        ),
      );
    } catch (e) {
      emit(JoinBlockError('Erro inesperado: ${extractUserMessage(e)}'));
    } finally {
      _isLoading = false;
    }
  }
}
