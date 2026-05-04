import 'package:bloco_na_rua/core/api_error.dart';
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

  Future<void> loadBlock() async {
    emit(BlockDetailsLoading());

    final result = await _carnivalBlocksRepository.getByIdAsync(
      int.parse(_carnivalBlockId),
    );

    if (result.isError()) {
      final failure = result.exceptionOrNull();
      emit(BlockDetailsError(_extractUserMessage(failure)));
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

    emit(BlockDetailsLoaded(
      carnivalBlock: block,
      canManageMembers: canManage,
    ));
  }
}