import 'dart:math';

import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBlockCubit extends Cubit<CreateBlockState> {
  CreateBlockCubit({
    required ICarnivalBlocksRepository carnivalBlocksRepository,
    required ICarnivalBlockMembersRepository carnivalBlockMembersRepository,
    required GetCurrentUserData getCurrentUserData,
  }) : _carnivalBlocksRepository = carnivalBlocksRepository,
       _carnivalBlockMembersRepository = carnivalBlockMembersRepository,
       _getCurrentUserData = getCurrentUserData,
       super(CreateBlockInitial());

  final ICarnivalBlocksRepository _carnivalBlocksRepository;
  final ICarnivalBlockMembersRepository _carnivalBlockMembersRepository;
  final GetCurrentUserData _getCurrentUserData;

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

  Future<void> createBlock(String name) async {
    emit(CreateBlockLoading());

    try {
      // 1. Get current user
      final userResult = await _getCurrentUserData();
      if (userResult.isError()) {
        emit(CreateBlockError('Erro ao obter dados do usuário: ${_extractUserMessage(userResult.exceptionOrNull())}'));
        return;
      }
      final user = userResult.getOrNull()!;

      // 2. Create the block with user as owner
      final inviteCode = _generateInviteCode();
      final data = {
        'name': name,
        'ownerId': user.id,
        'inviteCode': inviteCode,
        'managersInviteCode': inviteCode,
        'carnivalBlockImage': '',
      };

      final result = await _carnivalBlocksRepository.createAsync(data);

      // Handle result
      final block = result.fold(
        (block) => block,
        (failure) {
          emit(CreateBlockError(_extractUserMessage(failure)));
          return null;
        },
      );

      // If block creation failed, exit early
      if (block == null) return;

      // 3. Add creator as first member (role 0 = Member)
      final memberResult = await _carnivalBlockMembersRepository.createAsync(
        block.id,
        user.id,
        0,
      );

      memberResult.fold(
        (_) => emit(CreateBlockSuccess()),
        (failure) => emit(CreateBlockError('Bloco criado, mas erro ao registrar membro: ${_extractUserMessage(failure)}')),
      );
    } catch (e) {
      emit(CreateBlockError('Erro inesperado: ${_extractUserMessage(e)}'));
    }
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
