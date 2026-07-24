import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockDetailsCubit extends Cubit<BlockDetailsState> {
  BlockDetailsCubit({
    required ICarnivalBlocksRepository carnivalBlocksRepository,
    required GetCurrentUserData getCurrentUserData,
    required String carnivalBlockId,
  }) : _carnivalBlocksRepository = carnivalBlocksRepository,
       _getCurrentUserData = getCurrentUserData,
       _carnivalBlockId = carnivalBlockId,
       super(BlockDetailsInitial()) {
    loadBlock();
  }

  final ICarnivalBlocksRepository _carnivalBlocksRepository;
  final GetCurrentUserData _getCurrentUserData;
  final String _carnivalBlockId;

  Future<void> loadBlock() async {
    emit(BlockDetailsLoading());

    final result = await _carnivalBlocksRepository.getByIdAsync(
      int.parse(_carnivalBlockId),
    );

    if (result.isError()) {
      final failure = result.exceptionOrNull();
      emit(BlockDetailsError(extractUserMessage(failure)));
      return;
    }

    final block = result.getOrNull();
    if (block == null) {
      emit(BlockDetailsError('Bloco não encontrado'));
      return;
    }

    final userResult = await _getCurrentUserData();
    final canManage = userResult.fold(
      (user) => user.id == block.ownerId,
      (_) => false,
    );

    emit(BlockDetailsLoaded(carnivalBlock: block, canManageMembers: canManage));
  }
}
