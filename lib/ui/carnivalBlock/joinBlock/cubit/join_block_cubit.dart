import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinBlockCubit extends Cubit<JoinBlockState> {
  JoinBlockCubit({
    required ICarnivalBlocksRepository carnivalBlocksRepository,
    required ICarnivalBlockMembersRepository carnivalBlockMembersRepository,
    required GetCurrentUserData getCurrentUserData,
  }) : _carnivalBlocksRepository = carnivalBlocksRepository,
       _carnivalBlockMembersRepository = carnivalBlockMembersRepository,
       _getCurrentUserData = getCurrentUserData,
       super(JoinBlockInitial());

  final ICarnivalBlocksRepository _carnivalBlocksRepository;
  final ICarnivalBlockMembersRepository _carnivalBlockMembersRepository;
  final GetCurrentUserData _getCurrentUserData;

  Future<void> joinBlock(String inviteCode) async {
    if (inviteCode.isEmpty) {
      emit(const JoinBlockError('O código de convite não pode estar vazio.'));
      return;
    }

    emit(JoinBlockLoading());

    try {
      // 1. Get current user
      final userResult = await _getCurrentUserData();
      if (userResult.isError()) {
        emit(
          JoinBlockError(
            'Erro ao obter dados do usuário: ${extractUserMessage(userResult.exceptionOrNull())}',
          ),
        );
        return;
      }
      final user = userResult.getOrNull()!;

      // 2. Find block by invite code
      final blockResult = await _carnivalBlocksRepository.getByInviteCodeAsync(
        inviteCode,
      );
      if (blockResult.isError()) {
        emit(
          JoinBlockError(
            'Erro ao buscar bloco: ${extractUserMessage(blockResult.exceptionOrNull())}',
          ),
        );
        return;
      }

      final block = blockResult.getOrNull()!;

      // 3. Join the block
      // Role 0 is Member (based on RolesEnum in swagger.json)
      final joinResult = await _carnivalBlockMembersRepository.createAsync(
        block.id,
        user.id,
        0,
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
    }
  }
}
