import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/domain/use_cases/home/get_home_data_use_case.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:logging/logging.dart";

/// Cubit that manages the Block List screen state.
///
/// Loads the list of carnival blocks for the authenticated user and handles
/// loading, success, and failure states with user-friendly error messages.
class BlockListCubit extends Cubit<BlockListState> {
  /// Creates a [BlockListCubit] with the required [GetHomeDataUseCase].
  ///
  /// The use case is injected via dependency injection.
  BlockListCubit({required GetHomeDataUseCase getHomeDataUseCase})
    : _getHomeDataUseCase = getHomeDataUseCase,
      super(BlockListState.initial());

  final GetHomeDataUseCase _getHomeDataUseCase;
  final _log = Logger("BlockListCubit");

  /// Loads the list of carnival blocks for the authenticated user.
  ///
  /// Emits [BlockListState.loading] first, then either:
  /// - [BlockListState.success] with the blocks list on success
  /// - [BlockListState.failure] with a user-friendly error message on failure
  Future<void> loadBlocks() async {
    emit(BlockListState.loading());

    final result = await _getHomeDataUseCase.getCarnivalBlocks();

    result.fold((blocks) => emit(BlockListState.success(blocks)), (error) {
      _log.warning("Failed to load blocks", error);
      emit(BlockListState.failure(extractUserMessage(error)));
    });
  }
}
