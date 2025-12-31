import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockDetails/cubit/block_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockDetailsCubit extends Cubit<BlockDetailsState> {
  BlockDetailsCubit({
    required ICarnivalBlocksRepository carnivalBlocksRepository,
    required String carnivalBlockId,
  })  : _carnivalBlocksRepository = carnivalBlocksRepository,
        _carnivalBlockId = carnivalBlockId,
        super(BlockDetailsInitial()) {
    loadBlock();
  }

  final ICarnivalBlocksRepository _carnivalBlocksRepository;
  final String _carnivalBlockId;

  Future<void> loadBlock() async {
    emit(BlockDetailsLoading());

    final result = await _carnivalBlocksRepository.getByIdAsync(
      int.parse(_carnivalBlockId),
    );

    result.fold(
      (block) => emit(BlockDetailsLoaded(block)),
      (failure) => emit(BlockDetailsError(failure.toString())),
    );
  }
}
