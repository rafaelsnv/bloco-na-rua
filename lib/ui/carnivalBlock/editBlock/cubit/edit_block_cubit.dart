import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBlockCubit extends Cubit<EditBlockState> {
  EditBlockCubit({
    required ICarnivalBlocksRepository carnivalBlocksRepository,
    required String carnivalBlockId,
  }) : _carnivalBlocksRepository = carnivalBlocksRepository,
       _carnivalBlockId = carnivalBlockId,
       super(EditBlockInitial()) {
    loadBlock();
  }

  final ICarnivalBlocksRepository _carnivalBlocksRepository;
  final String _carnivalBlockId;

  Future<void> loadBlock() async {
    emit(EditBlockLoading());

    final result = await _carnivalBlocksRepository.getByIdAsync(
      int.parse(_carnivalBlockId),
    );

    result.fold(
      (block) => emit(
        EditBlockLoaded(
          id: block.id,
          name: block.name,
          carnivalBlockImage: block.carnivalBlockImage,
        ),
      ),
      (failure) => emit(EditBlockError(extractUserMessage(failure))),
    );
  }

  Future<void> updateBlock({
    required String name,
    required String carnivalBlockImage,
  }) async {
    emit(EditBlockSaving());

    final data = {'name': name, 'carnivalBlockImage': carnivalBlockImage};

    final result = await _carnivalBlocksRepository.updateAsync(
      int.parse(_carnivalBlockId),
      data,
    );

    result.fold(
      (_) => emit(EditBlockSuccess()),
      (failure) => emit(EditBlockError(extractUserMessage(failure))),
    );
  }
}
